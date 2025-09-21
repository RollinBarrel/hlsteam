LBITS := $(shell getconf LONG_BIT)

UNAME := $(shell uname)

CFLAGS = -Wall -fPIC -I sdk/public -I $(HASHLINK_SRC)/src -std=c++0x
CFLAGS += -g 

ifeq ($(UNAME),Darwin)
OS=osx
ARCH=
else
OS=linux
ARCH=$(LBITS)
endif

LFLAGS = -lhl -lsteam_api -lstdc++ -Wl,-rpath,. -L sdk/redistributable_bin/$(OS)$(ARCH)

ifdef OSX_SDK
ISYSROOT = $(shell xcrun --sdk macosx$(OSX_SDK) --show-sdk-path)
CFLAGS += -isysroot $(ISYSROOT)
LFLAGS += -isysroot $(ISYSROOT)
endif

SRC = native/cloud.o native/common.o native/controller.o native/friends.o native/gameserver.o \
	native/matchmaking.o native/networking.o native/networkingmessages.o native/stats.o \
	native/ugc.o native/timeline.o


all: ${SRC}
	${CC} ${CFLAGS} -shared -o steam.hdll ${SRC} ${LFLAGS}

install:
	cp steam.hdll /usr/lib
	cp native/lib/$(OS)$(ARCH)/libsteam_api.* /usr/lib
	
.SUFFIXES : .cpp .o

.cpp.o :
	${CC} ${CFLAGS} -o $@ -c $<
	
clean_o:
	rm -f ${SRC}

clean: clean_o
	rm -f steam.hdll

