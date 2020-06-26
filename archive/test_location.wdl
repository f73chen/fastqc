workflow test_location {
    call find_tools
}

task find_tools {
    command {
        ls $FASTQC_ROOT
        echo "@@@@@@@@@@@@@@@@"
        ls $JAVA_ROOT
        echo "@@@@@@@@@@@@@@@@"
        ls $PERL_ROOT
        echo "@@@@@@@@@@@@@@@@"

        echo $PATH
        echo "################"
        echo $MANPATH
        echo "################"
        echo $LD_LIBRARY_PATH
        echo "################"
        echo $PERL5LIB
        echo "################"
    }
    output{
        String message = read_string(stdout())
    }
    runtime {
        modules: "fastqc/0.11.8 perl/5.30"
    }
}
