# docker_esp32_adf_build
## 简介

使用docker来构建你的专属esp32-adf编译环境。

## 使用

1. 根据Dockerfile来构建你自己的镜像

   ```shell
   # -t 镜像名:tag版本号
   docker build -t esp32_adf_build:0.1 .
   ```

   如果没有意外，则会生成一个新的镜像

   ```shell
   Step 1/18 : FROM ubuntu
    ---> ba6acccedd29
   Step 2/18 : MAINTAINER xph<xupenghu@outlook.com>
    ---> Using cache
    ---> d0a32861ab27
   Step 3/18 : ENV MYPATH /usr/home
    ---> Using cache
    ---> cdab19bc4793
   Step 4/18 : WORKDIR $MYPATH
    ---> Using cache
    ---> 99320cd58c13
   Step 5/18 : COPY README.md	/usr/home/README.md
    ---> Using cache
    ---> ebc075cb565d
   Step 6/18 : RUN  mv /etc/apt/sources.list /etc/apt/sources.list.bak
    ---> Using cache
    ---> 0825f75167e1
   Step 7/18 : COPY sources.list /etc/apt/sources.list
    ---> Using cache
    ---> 5639eccb7973
   Step 8/18 : RUN apt update
    ---> Using cache
    ---> 664e9ff152e3
   Step 9/18 : RUN apt-get update
    ---> Using cache
    ---> 9db319ef8d3c
   Step 10/18 : ENV DEBIAN_FRONTEND=noninteractive
    ---> Using cache
    ---> 77fbb19272a5
   Step 11/18 : RUN apt-get install -y -q --fix-missing git python3 python3-pip libusb-1.0 cmake make dialog apt-utils
    ---> Using cache
    ---> c82ecbce36a0
   Step 12/18 : RUN ln -s /usr/bin/python3 /usr/bin/python
    ---> Using cache
    ---> 0c679d12d178
   Step 13/18 : RUN git clone --recursive -b v2.3 https://github.com/espressif/esp-adf
    ---> Using cache
    ---> b36cd98d68a1
   Step 14/18 : RUN /usr/home/esp-adf/esp-idf/install.sh
    ---> Using cache
    ---> 16bbf37f4d2c
   Step 15/18 : ENV IDF_PATH=/usr/home/esp-adf/esp-idf
    ---> Using cache
    ---> 07609aed5502
   Step 16/18 : ENV ADF_PATH=/usr/home/esp-adf/
    ---> Using cache
    ---> f69f7e36ef7e
   Step 17/18 : CMD echo "----end----"
    ---> Running in 891517f4a60e
   Removing intermediate container 891517f4a60e
    ---> 92e906ab65ef
   Step 18/18 : CMD /bin/bash
    ---> Running in fdbee439a1f6
   Removing intermediate container fdbee439a1f6
    ---> bf2ca6c16c91
   Successfully built bf2ca6c16c91
   Successfully tagged esp32_adf_build:0.1
   ```

   

2. 运行该镜像

   ```shell
   # 1. 进入该镜像
   $docker run -it esp32_adf_build:0.1 /bin/bash
   # 2. 新建一个文件夹，拷贝esp-adf的示例工程到该文件夹下
   $mkdir my_esp32_adf_project
   $cp ../esp-adf/examples/get-started/play_mp3 ./ -r
   $cd play_mp3
   # 3. 在当前目录下导入esp的idf编译环境 
   root@6c30998bb7a4:/usr/home/my_esp32_adf_project/play_mp3# . $IDF_PATH/export.sh
   Adding ESP-IDF tools to PATH...
   Checking if Python packages are up to date...
   Python requirements from /usr/home/esp-adf/esp-idf/requirements.txt are satisfied.
   Added the following directories to PATH:
     /usr/home/esp-adf/esp-idf/components/esptool_py/esptool
     /usr/home/esp-adf/esp-idf/components/espcoredump
     /usr/home/esp-adf/esp-idf/components/partition_table/
   Done! You can now compile ESP-IDF projects.
   Go to the project directory and run:
   
     idf.py build
   # 4. 编译示例工程
   $idf.py build
   
   # 5. 如果不出意外，则会生成对应的固件
   ...
   Scanning dependencies of target ldgen_section_infos
   [ 98%] Built target ldgen_section_infos
   Scanning dependencies of target ldgen_esp32.project.ld_script
   [ 98%] Generating esp32.project.ld
   [ 98%] Built target ldgen_esp32.project.ld_script
   Scanning dependencies of target ldgen
   [ 98%] Built target ldgen
   Scanning dependencies of target play_mp3.elf
   [ 98%] Building C object CMakeFiles/play_mp3.elf.dir/dummy_main_src.c.obj
   [100%] Linking CXX executable play_mp3.elf
   [100%] Built target play_mp3.elf
   Scanning dependencies of target app
   [100%] Generating play_mp3.bin
   esptool.py v2.8
   [100%] Built target app
   
   Project build complete. To flash, run this command:
   ../../esp-adf/esp-idf/components/esptool_py/esptool/esptool.py -p (PORT) -b 460800 --after hard_reset write_flash --flash_mode dio --flash_size detect --flash_freq 40m 0x1000 build/bootloader/bootloader.bin 0x8000 build/partition_table/partition-table.bin 0x10000 build/play_mp3.bin
   or run 'idf.py -p (PORT) flash'
   root@6c30998bb7a4:/usr/home/my_esp32_adf_project/play_mp3# 
   
   ```


## 直接从docker hub上获取该镜像

当然你也可以直接从docker hub上获取该镜像直接使用

```shell
docker push hubertxxu/esp32_adf_build:0.1
```

# 快速开始

1. 首先你需要将自己的ESP-ADF工程文件夹和此docker镜像相关联，这用到了docker的[容器数据卷](https://blog.csdn.net/u014421520/article/details/120248472)。当然你也可以直接用乐鑫的[ESP32-ADF](https://github.com/espressif/esp-adf/tree/master/examples)的示例程序测试。

2. 启动docker镜像，并挂载你的ESP-ADF工程，我以ESP-ADF的example示例来演示一下

   - 这是一个标准的esp32_adf的示例工程，它的目录结构如下：

   ```shel
   [root@VM-87-165-centos ~/github/esp-adf-2.3/examples/get-started/play_mp3]# tree -L 2
   .
   ├── CMakeLists.txt
   ├── components
   │   └── my_board
   ├── example_test.py
   ├── main
   │   ├── adf_music.mp3
   │   ├── CMakeLists.txt
   │   ├── component.mk
   │   └── play_mp3_example.c
   ├── Makefile
   └── README.md
   ```

   - 我将它挂载到docker esp32_adf_build镜像，并启动该镜像。

   ```shel
    ~/github/esp-adf-2.3/examples/get-started/play_mp3]# docker run -it -v ./:/home/workspace/play_mp3 eps32_adf_build:0.1 /bin/bash
   ```

   - 进入该容器后，开启idf编译环境

   ```shel
   root@3f76de1abd22:/home/workspace/play_mp3# . $IDF_PATH/export.sh
   Adding ESP-IDF tools to PATH...
   Checking if Python packages are up to date...
   Python requirements from /usr/home/esp-adf/esp-idf/requirements.txt are satisfied.
   Added the following directories to PATH:
     /usr/home/esp-adf/esp-idf/components/esptool_py/esptool
     /usr/home/esp-adf/esp-idf/components/espcoredump
     /usr/home/esp-adf/esp-idf/components/partition_table/
     /root/.espressif/tools/xtensa-esp32-elf/1.22.0-80-g6c4433a-5.2.0/xtensa-esp32-elf/bin
     /root/.espressif/tools/esp32ulp-elf/2.28.51.20170517/esp32ulp-elf-binutils/bin
     /root/.espressif/tools/openocd-esp32/v0.10.0-esp32-20190313/openocd-esp32/bin
     /root/.espressif/python_env/idf3.3_py3.8_env/bin
     /usr/home/esp-adf/esp-idf/tools
   Done! You can now compile ESP-IDF projects.
   Go to the project directory and run:
   
     idf.py build
   ```

   - 然后执行编译

   ```shel
   #idf.py build
   ```

   - 编译完成后，我们退出容器，在我们的工程目录下就找到了编译好的镜像

   ```shell
   [root@VM-87-165-centos ~/github/esp-adf-2.3/examples/get-started/play_mp3]# tree -L 2
   .
   ├── build
   │   ├── adf_music.mp3.S
   │   ├── bootloader
   │   ├── bootloader-prefix
   │   ├── CMakeCache.txt
   │   ├── CMakeFiles
   │   ├── cmake_install.cmake
   │   ├── compile_commands.json
   │   ├── component_depends.cmake
   │   ├── config
   │   ├── duer_profile.S
   │   ├── dummy_main_src.c
   │   ├── esp-idf
   │   ├── flash_app_args
   │   ├── flash_bootloader_args
   │   ├── flasher_args.json
   │   ├── flash_partition_table_args
   │   ├── flash_project_args
   │   ├── kconfig_bin
   │   ├── ldgen.section_infos
   │   ├── Makefile
   │   ├── mconf-idf-prefix
   │   ├── partition_table
   │   ├── play_mp3.bin
   │   ├── play_mp3.elf
   │   ├── play_mp3.map
   │   └── project_description.json
   ├── CMakeLists.txt
   ├── components
   │   └── my_board
   ├── example_test.py
   ├── main
   │   ├── adf_music.mp3
   │   ├── CMakeLists.txt
   │   ├── component.mk
   │   └── play_mp3_example.c
   ├── Makefile
   ├── README.md
   └── sdkconfig
   
   12 directories, 27 files
   ```

   - 直接烧录到ESP32即可
