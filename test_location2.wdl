workflow test_location {
    call find_tools
}

task find_tools {
    command <<<
        ls -l /data/HG38_STAR_INDEX100_ROOT/
        echo "@@@@@@@@@@@@@"
    >>>
    output{
        String message = read_string(stdout())
    }
    runtime {
        docker: "g3chen/starmulti@sha256:0c35fb8426d1045d55544aec97305ec584ec3dfb80d41ccf1adba39a773bec04"
    }
}
