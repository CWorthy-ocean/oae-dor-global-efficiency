set(SUPPORTS_CXX "FALSE")
if("${COMPILER}" STREQUAL "gnu")
  set(MPIFC "mpif90")
  set(FFLAGS_NOOPT "-O0")
  set(MPICC "mpicc")
  set(SCC "gcc")
  set(MPICXX "mpicxx")
  set(HAS_F2008_CONTIGUOUS "FALSE")
  set(SUPPORTS_CXX "TRUE")
  set(FFLAGS "-fconvert=big-endian -ffree-line-length-none -ffixed-line-length-none")
  set(FIXEDFLAGS "-ffixed-form")
  set(CXX_LINKER "FORTRAN")
  set(FC_AUTO_R8 "-fdefault-real-8")
  set(CFLAGS "-std=gnu99")
  set(FREEFLAGS "-ffree-form")
  set(SFC "gfortran")
  set(SCXX "g++")
endif()
if("${COMPILER}" STREQUAL "intel")
  set(MPIFC "mpif90")
  set(FFLAGS_NOOPT "-O0")
  set(MPICC "mpicc")
  set(SCC "icc")
  set(MPICXX "mpicxx")
  set(CXX_LDFLAGS "-cxxlib")
  set(SUPPORTS_CXX "TRUE")
  set(FFLAGS "-qno-opt-dynamic-align  -convert big_endian -assume byterecl -ftz -traceback -assume realloc_lhs -fp-model source")
  set(FIXEDFLAGS "-fixed")
  set(CXX_LINKER "FORTRAN")
  set(FC_AUTO_R8 "-r8")
  set(CFLAGS "-qno-opt-dynamic-align -fp-model precise -std=gnu99")
  set(FREEFLAGS "-free")
  set(SFC "ifort")
  set(SCXX "icpc")
endif()
if("${COMPILER}" STREQUAL "pgi")
  set(MPIFC "mpif90")
  set(FFLAGS_NOOPT "-O0")
  set(MPICC "mpicc")
  set(SCC "pgcc")
  set(LDFLAGS "-time -Wl,--allow-multiple-definition")
  set(MPICXX "mpicxx")
  set(HAS_F2008_CONTIGUOUS "FALSE")
  set(FFLAGS "-i4 -gopt  -time -Mextend -byteswapio -Mflushz -Kieee")
  set(FIXEDFLAGS "-Mfixed")
  set(CXX_LINKER "CXX")
  set(FC_AUTO_R8 "-r8")
  set(CFLAGS "-gopt  -time")
  set(FREEFLAGS "-Mfree")
  set(SFC "pgf95")
  set(SCXX "pgc++")
endif()
set(PIO_FILESYSTEM_HINTS "gpfs")
set(PNETCDF_PATH "$ENV{PNETCDF}")
set(NETCDF_PATH "$ENV{NETCDF}")
if("${COMPILER}" STREQUAL "intel")
  set(HAS_F2008_CONTIGUOUS "TRUE")
  if("${MPILIB}" STREQUAL "mpt")
    if("${compile_threaded}" STREQUAL "TRUE")
      set(PFUNIT_PATH "$ENV{CESMDATAROOT}/tools/pFUnit/pFUnit3.2.8_cheyenne_Intel17.0.1_MPI_openMP")
    endif()
  endif()
  if("${MPILIB}" STREQUAL "mpi-serial")
    if("${compile_threaded}" STREQUAL "FALSE")
      set(PFUNIT_PATH "$ENV{CESMDATAROOT}/tools/pFUnit/pFUnit3.2.8_cheyenne_Intel17.0.1_noMPI_noOpenMP")
    endif()
  endif()
endif()
set(CPPDEFS "${CPPDEFS}  -DCESMCOUPLED")
if("${MODEL}" STREQUAL "gptl")
  set(CPPDEFS "${CPPDEFS}  -DHAVE_NANOTIME -DBIT64 -DHAVE_VPRINTF -DHAVE_BACKTRACE -DHAVE_SLASHPROC -DHAVE_COMM_F2C -DHAVE_TIMES -DHAVE_GETTIMEOFDAY")
endif()
if("${MODEL}" STREQUAL "mom")
  set(FFLAGS "${FFLAGS}  $(FC_AUTO_R8) -Duse_LARGEFILE")
endif()
if("${MODEL}" STREQUAL "pop")
  set(CPPDEFS "${CPPDEFS}  -D_USE_FLOW_CONTROL")
endif()
if("${MODEL}" STREQUAL "ufsatm")
  set(CPPDEFS "${CPPDEFS}  -DSPMD")
  set(FFLAGS "${FFLAGS}  $(FC_AUTO_R8)")
endif()
if("${COMPILER}" STREQUAL "gnu")
  set(CPPDEFS "${CPPDEFS}  -DFORTRANUNDERSCORE -DNO_R16 -DCPRGNU")
  set(SLIBS "${SLIBS}  -ldl")
  if("${compile_threaded}" STREQUAL "TRUE")
    set(FFLAGS "${FFLAGS}  -fopenmp")
    set(CFLAGS "${CFLAGS}  -fopenmp")
  endif()
  if("${DEBUG}" STREQUAL "TRUE")
    set(FFLAGS "${FFLAGS}  -g -Wall -Og -fbacktrace -ffpe-trap=zero,overflow -fcheck=bounds")
    set(CFLAGS "${CFLAGS}  -g -Wall -Og -fbacktrace -ffpe-trap=invalid,zero,overflow -fcheck=bounds")
  endif()
  if("${DEBUG}" STREQUAL "FALSE")
    set(FFLAGS "${FFLAGS}  -O")
    set(CFLAGS "${CFLAGS}  -O")
  endif()
  if("${MODEL}" STREQUAL "pio1")
    set(CPPDEFS "${CPPDEFS}  -DNO_MPIMOD")
  endif()
  if("${compile_threaded}" STREQUAL "TRUE")
    set(LDFLAGS "${LDFLAGS}  -fopenmp")
  endif()
endif()
if("${COMPILER}" STREQUAL "intel")
  set(FFLAGS "${FFLAGS}  -qopt-report -xCORE_AVX2 -no-fma")
  set(CPPDEFS "${CPPDEFS}  -DFORTRANUNDERSCORE -DCPRINTEL")
  set(CFLAGS "${CFLAGS}  -qopt-report -xCORE_AVX2 -no-fma")
  if("${compile_threaded}" STREQUAL "TRUE")
    set(FFLAGS "${FFLAGS}  -qopenmp")
    set(CFLAGS "${CFLAGS}  -qopenmp")
  endif()
  if("${DEBUG}" STREQUAL "TRUE")
    set(FFLAGS "${FFLAGS}  -O0 -g -check uninit -check bounds -check pointers -fpe0 -check noarg_temp_created")
    set(CMAKE_OPTS "${CMAKE_OPTS}  -DPIO_ENABLE_LOGGING=ON")
    set(CFLAGS "${CFLAGS}  -O0 -g")
  endif()
  if("${DEBUG}" STREQUAL "FALSE")
    set(FFLAGS "${FFLAGS}  -O2 -debug minimal")
    set(CFLAGS "${CFLAGS}  -O2 -debug minimal")
  endif()
  if("${MPILIB}" STREQUAL "mvapich2")
    set(SLIBS "${SLIBS}  -mkl=cluster")
  endif()
  if("${MPILIB}" STREQUAL "mpich2")
    set(SLIBS "${SLIBS}  -mkl=cluster")
  endif()
  if("${MPILIB}" STREQUAL "mpt")
    set(SLIBS "${SLIBS}  -mkl=cluster")
  endif()
  if("${MPILIB}" STREQUAL "openmpi")
    set(SLIBS "${SLIBS}  -mkl=cluster")
  endif()
  if("${MPILIB}" STREQUAL "mpich")
    set(SLIBS "${SLIBS}  -mkl=cluster")
  endif()
  if("${MPILIB}" STREQUAL "mvapich")
    set(SLIBS "${SLIBS}  -mkl=cluster")
  endif()
  if("${MPILIB}" STREQUAL "impi")
    set(SLIBS "${SLIBS}  -mkl=cluster")
  endif()
  if("${MPILIB}" STREQUAL "mpi-serial")
    set(SLIBS "${SLIBS}  -mkl")
  endif()
  if("${compile_threaded}" STREQUAL "TRUE")
    set(LDFLAGS "${LDFLAGS}  -qopenmp")
  endif()
endif()
if("${COMPILER}" STREQUAL "pgi")
  set(SLIBS "${SLIBS}  -llapack -lblas")
  set(CPPDEFS "${CPPDEFS}  -DFORTRANUNDERSCORE -DNO_SHR_VMATH -DNO_R16  -DCPRPGI")
  if("${compile_threaded}" STREQUAL "TRUE")
    set(FFLAGS "${FFLAGS}  -mp")
  endif()
  if("${MODEL}" STREQUAL "dwav")
    set(FFLAGS "${FFLAGS}  -Mnovect")
  endif()
  if("${MODEL}" STREQUAL "dice")
    set(FFLAGS "${FFLAGS}  -Mnovect")
  endif()
  if("${MODEL}" STREQUAL "dlnd")
    set(FFLAGS "${FFLAGS}  -Mnovect")
  endif()
  if("${MODEL}" STREQUAL "datm")
    set(FFLAGS "${FFLAGS}  -Mnovect")
  endif()
  if("${MODEL}" STREQUAL "docn")
    set(FFLAGS "${FFLAGS}  -Mnovect")
  endif()
  if("${MODEL}" STREQUAL "drof")
    set(FFLAGS "${FFLAGS}  -Mnovect")
  endif()
  if("${DEBUG}" STREQUAL "TRUE")
    set(FFLAGS "${FFLAGS}  -O0 -g -Ktrap=fp -Mbounds -Kieee")
  endif()
  if("${MPILIB}" STREQUAL "mpi-serial")
    set(SLIBS "${SLIBS}  -ldl")
  endif()
  if("${compile_threaded}" STREQUAL "TRUE")
    set(LDFLAGS "${LDFLAGS}  -mp")
    set(CFLAGS "${CFLAGS}  -mp")
  endif()
endif()
if("${MODEL}" STREQUAL "ufsatm")
  set(INCLDIR "${INCLDIR}  -I$(EXEROOT)/atm/obj/FMS")
endif()
