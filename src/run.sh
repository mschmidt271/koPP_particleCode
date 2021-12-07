#!/bin/bash

# OpenMP environment variables
export OMP_NUM_THREADS=8
export OMP_PROC_BIND=spread
export OMP_PLACES=cores

# whether we are on a remote computer and don't want to plot
export remote=true
# export laptop=true

# simple kernel timer location
export simple_kt=true
export KOKKOS_PROFILE_LIBRARY=${HOME}/kokkos-tools/kp_kernel_timer.so
export PATH=${PATH}:${HOME}/kokkos-tools/

# space time stack
# export st_stack=true
# export KOKKOS_PROFILE_LIBRARY=${HOME}/kokkos-tools/profiling/space-time-stack/kp_space_time_stack.so
# export PATH=${PATH}:${HOME}/kokkos-tools/profiling/

# memory events
# export KOKKOS_PROFILE_LIBRARY=${HOME}/kokkos-tools/profiling/memory-events/kp_memory_events.so
# export PATH=${PATH}:${HOME}/kokkos-tools/profiling/

# kernel logger
# export KOKKOS_PROFILE_LIBRARY=${HOME}/kokkos-tools/kp_kernel_logger.so
# export PATH=${PATH}:${HOME}/kokkos-tools/

if [ "$laptop" = true ]
then
    if [ "$st_stack" = true ]
    then
        ./bin/parPT /data/particleParams.yaml -v > prof_results.txt
        subl prof_results.txt
        # echo "a"
    elif [ "$simple_kt" = true ]
    then
        ./bin/parPT /data/particleParams.yaml -v
        kp_reader *.json > prof_results.txt
        rm s1046231*.json
        subl prof_results.txt
        # echo "b"
        # rm prof_results.txt
    else
        # run the program and redirect the error output (cpu)
        ./bin/parPT /data/particleParams.yaml --kokkos-threads=8 -v 2> data/a.err
        # echo "c"
        # ./bin/parPT /data/particleParams.yaml -v
        cd plotting
        python3 plotParticles.py3
        cd ..
        # run the program and redirect screen and error output
        # ./parPT.exe > a.out 2> a.err
    fi
elif [ "$remote" = true ]
then
    if [ "$simple_kt" = true ]
    then
        ./bin/parPT /data/particleParams.yaml -v
        kp_reader *.json > prof_results.txt
        rm s1024454*.json
        vim prof_results.txt
        # echo "b"
        # rm prof_results.txt
    else
        ./bin/parPT /data/particleParams.yaml -v 2> data/a.err
    fi
fi
