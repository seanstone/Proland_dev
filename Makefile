CPPFLAGS += -DORK_API= -DTIXML_USE_STL -DPROLAND_API= -DUSE_SHARED_PTR

LIBS = core terrain atmo ocean forest graph river edit
lib: $(LIBS)
.PHONY: lib $(LIBS)
$(LIBS): export SRC = $(shell find $@/sources -name *.cpp)
$(LIBS): export CPPFLAGS += $(patsubst %,-I%/sources,$(LIBS))
$(LIBS):
	$(MAKE) build/libproland-$@.a

build/libproland-%.a: $(addprefix build/,$(SRC:.cpp=.o))
	ar rcsv $@ $^

build/%.o: %.cpp
	mkdir -p $(@D)
	g++ $(CPPFLAGS) -c $< -o $@

clean:
	rm -rf build
