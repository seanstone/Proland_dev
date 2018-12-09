CPPFLAGS += -DORK_API= -DTIXML_USE_STL -DPROLAND_API= -DUSE_SHARED_PTR
CXXFLAGS += -std=c++11

LIBS = core terrain atmo ocean forest graph river edit
lib: $(LIBS)
.PHONY: lib $(LIBS)
$(LIBS): export SRC = $(shell find $@/sources -name *.cpp)
$(LIBS): export CPPFLAGS += $(patsubst %,-I%/sources,$(LIBS))
$(LIBS):
	$(MAKE) build/lib/libproland-$@.a

build/lib/libproland-%.a: $(addprefix build/obj/,$(SRC:.cpp=.o))
	mkdir -p $(@D)
	ar rcsv $@ $^

.PRECIOUS: build/obj/%.o
build/obj/%.o: %.cpp
	mkdir -p $(@D)
	g++ $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

.PHONY: examples
examples: $(patsubst %/,build/bin/%,$(dir $(wildcard core/examples/*/*.cpp)))

reverse = $(if $(1),$(call reverse,$(wordlist 2,$(words $(1)),$(1)))) $(firstword $(1))
LDFLAGS += -Lbuild/lib
#LDFLAGS += $(addprefix -l,$(addprefix proland-,$(call reverse,$(LIBS)))) -lork
LDFLAGS += -lproland-core
LDFLAGS += -Wl,--whole-archive -lork -Wl,--no-whole-archive
LDLIBS += pthread GL GLU GLEW glut glfw3 rt dl Xi Xrandr Xinerama Xxf86vm Xext Xcursor Xrender Xfixes X11 AntTweakBar stb_image tinyxml
LDFLAGS += $(addprefix -l,$(LDLIBS))
CPPFLAGS += -Icore/sources

build/bin/%: %/*.cpp
	mkdir -p $(@D)
	g++ $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -rf build
