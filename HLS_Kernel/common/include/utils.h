/*
 * Copyright 2019 Xilinx, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef UTILS_H
#define UTILS_H

// ------------------------------------------------------------

#include <new>
#include <cstdlib>

template <typename T>
T* aligned_alloc(std::size_t num) {
    void* ptr = NULL;
    if (posix_memalign(&ptr, 4096, num * sizeof(T)))
        //  ptr= malloc(num*sizeof(T));
        //  if (ptr==NULL)
        throw std::bad_alloc();
    return reinterpret_cast<T*>(ptr);
}

// ------------------------------------------------------------

#include <algorithm>
#include <string>
#include <vector>

class ArgParser {
   public:
    ArgParser(int argc, const char* argv[]) {
        for (int i = 1; i < argc; ++i) mTokens.push_back(std::string(argv[i]));
    }
    bool getCmdOption(const std::string option, std::string& value) const {
        std::vector<std::string>::const_iterator itr;
        itr = std::find(this->mTokens.begin(), this->mTokens.end(), option);
        if (itr != this->mTokens.end()) {
            if (++itr != this->mTokens.end()) {
                value = *itr;
            }
            return true;
        }
        return false;
    }

   private:
    std::vector<std::string> mTokens;
};

inline bool has_end(std::string const& full, std::string const& end) {
    if (full.length() >= end.length()) {
        return (0 == full.compare(full.length() - end.length(), end.length(), end));
    } else {
        return false;
    }
}

// ------------------------------------------------------------

#include <sys/time.h>

inline int tvdiff(struct timeval* tv0, struct timeval* tv1) {
    return (tv1->tv_sec - tv0->tv_sec) * 1000000 + (tv1->tv_usec - tv0->tv_usec);
}

// ------------------------------------------------------------

#include <sys/types.h>
#include <sys/stat.h>

inline bool is_dir(const char* path) {
    struct stat info;
    if (stat(path, &info) != 0) return false;
    if (info.st_mode & S_IFDIR)
        return true;
    else
        return false;
}

inline bool is_dir(const std::string& path) {
    return is_dir(path.c_str());
}

inline bool is_file(const char* path) {
    struct stat info;
    if (stat(path, &info) != 0) return false;
    if (info.st_mode & (S_IFREG))
        return true;
    else
        return false;
}

inline bool is_file(const std::string& path) {
    return is_file(path.c_str());
}

// ------------------------------------------------------------

#ifndef HLS_TEST
#include <xcl/xcl2.hpp>

enum Direction {
    UNKNOWN = 0,
    INPUT,
    OUTPUT,
    INOUT,
};

class DPUKernel {
   private:
    cl::Context context_;
    cl::CommandQueue q_;
    cl::Kernel dpu_kernel_;

    std::vector<cl::Memory> ob_in_;
    std::vector<cl::Memory> ob_no_;
    std::vector<cl::Memory> ob_out_;
    std::vector<cl::Event> events_write_;
    std::vector<cl::Event> events_kernel_;
    std::vector<cl::Event> events_read_;

    struct timeval start_time_;
    struct timeval end_time_;

   public:
    int32_t init(int32_t device_id, std::string& xclbin_path, std::string& kernel_name) {
        int32_t err = 0;
        std::vector<cl::Device> devices = xcl::get_xil_devices();
        cl::Device device = devices[device_id];
        context_ = cl::Context(device, NULL, NULL, NULL, &err);
        q_ = cl::CommandQueue(context_, device, CL_QUEUE_PROFILING_ENABLE | CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE,
                              &err);
        std::string devName = device.getInfo<CL_DEVICE_NAME>();
        std::cout << "found device=" << device.getInfo<CL_DEVICE_NAME>() << std::endl;

        cl::Program::Binaries xclbins = xcl::import_binary_file(xclbin_path);
        cl::Program program(context_, {device}, xclbins, NULL, &err);
        dpu_kernel_ = cl::Kernel(program, kernel_name.c_str(), &err);
        std::cout << "kernel has been created" << std::endl;
        return err;
    }

    int32_t set_arg(uint32_t arg_id, Direction direction, void* ext_ptr, int64_t size) {
        int32_t err = 0;
        cl_mem_ext_ptr_t mem_ext_ptr;
        mem_ext_ptr = {arg_id, ext_ptr, dpu_kernel_()};
        cl::Buffer buf(context_, CL_MEM_EXT_PTR_XILINX | CL_MEM_USE_HOST_PTR | CL_MEM_READ_WRITE, size, &mem_ext_ptr);
        if (direction == INPUT)
            ob_in_.push_back(buf);
        else if (direction == OUTPUT)
            ob_out_.push_back(buf);
        else if (direction == INOUT) {
            ob_in_.push_back(buf);
            ob_out_.push_back(buf);
        }
        dpu_kernel_.setArg(arg_id, buf);
        return err;
    }

    int32_t run() {
        events_write_.resize(1);
        events_kernel_.resize(1);
        events_read_.resize(1);
        struct timeval start_time, end_time;
        std::cout << "kernel start..." << std::endl;
        gettimeofday(&start_time_, 0);
        q_.enqueueMigrateMemObjects(ob_in_, 0, nullptr, &events_write_[0]);
        q_.enqueueTask(dpu_kernel_, &events_write_, &events_kernel_[0]);
        q_.enqueueMigrateMemObjects(ob_out_, 1, &events_kernel_, &events_read_[0]);
        q_.finish();
        gettimeofday(&end_time_, 0);
        std::cout << "kernel end" << std::endl;
        return 0;
    }

    int32_t print_time() {
        uint64_t time1, time2;
        double diff_time;
        events_write_[0].getProfilingInfo(CL_PROFILING_COMMAND_START, &time1);
        events_write_[0].getProfilingInfo(CL_PROFILING_COMMAND_END, &time2);
        diff_time = (time2 - time1) / 1000000.0; // ms
        std::cout << "Host to DDR Execution time " << diff_time << " ms" << std::endl;
        events_kernel_[0].getProfilingInfo(CL_PROFILING_COMMAND_START, &time1);
        events_kernel_[0].getProfilingInfo(CL_PROFILING_COMMAND_END, &time2);
        diff_time = (time2 - time1) / 1000000.0; // ms
        std::cout << "Kernel Execution time " << diff_time << " ms" << std::endl;
        events_read_[0].getProfilingInfo(CL_PROFILING_COMMAND_START, &time1);
        events_read_[0].getProfilingInfo(CL_PROFILING_COMMAND_END, &time2);
        diff_time = (time2 - time1) / 1000000.0; // ms
        std::cout << "DDR to Host Execution time " << diff_time << " ms" << std::endl;
        std::cout << "Total Execution time " << tvdiff(&start_time_, &end_time_) / 1000.0 << "ms" << std::endl;
        return 0;
    }
};
#endif // HLS_TEST

#endif // UTILS_H
