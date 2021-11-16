FROM ubuntu		
MAINTAINER xph<xupenghu@outlook.com> 

ENV MYPATH /usr/home  
WORKDIR $MYPATH 		

COPY README.md	/usr/home/README.md
RUN  mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY sources.list /etc/apt/sources.list 

RUN apt update
RUN apt-get update

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y -q --fix-missing git python3 python3-pip libusb-1.0 cmake make dialog apt-utils

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN git clone --recursive -b v2.3 https://github.com/espressif/esp-adf

RUN /usr/home/esp-adf/esp-idf/install.sh

ENV IDF_PATH=/usr/home/esp-adf/esp-idf

ENV ADF_PATH=/usr/home/esp-adf/

CMD echo "----end----"
CMD /bin/bash
