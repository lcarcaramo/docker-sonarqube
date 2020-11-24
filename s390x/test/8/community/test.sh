#!/bin/bash

set -e

export ANSI_YELLOW_BOLD="\e[1;33m"
export ANSI_GREEN="\e[32m"
export ANSI_YELLOW_BACKGROUND="\e[1;7;33m"
export ANSI_GREEN_BACKGROUND="\e[1;7;32m"
export ANSI_CYAN_BACKGROUND="\e[1;7;36m"
export ANSI_CYAN="\e[36m"
export ANSI_RESET="\e[0m"
export DOCKERFILE_TOP="**************************************** DOCKERFILE ******************************************"
export DOCKERFILE_BOTTOM="**********************************************************************************************"
export TEST_SUITE_START="**************************************** SMOKE TESTS *****************************************"
export TEST_SUITE_END="************************************** TEST SUCCESSFUL ***************************************"

# Pass in path to folder where Dockerfile lives
print_dockerfile () {
        echo -e "\n$ANSI_CYAN$DOCKERFILE_TOP\n$(<$1/Dockerfile)\n$ANSI_CYAN$DOCKERFILE_BOTTOM $ANSI_RESET\n"
}

# Pass in test case message
print_test_case () {
        echo -e "\n$ANSI_YELLOW_BOLD$1 $ANSI_RESET"
}

print_success () {
        echo -e "\n$ANSI_GREEN$1 $ANSI_RESET \n"

}

wait_until_ready () {
        export SECONDS=$1
        export SLEEP_INTERVAL=$(echo $SECONDS 50 | awk '{ print $1/$2 }')

        echo -e "\n${ANSI_CYAN}Waiting ${SECONDS} seconds until ready: ${ANSI_RESET}"

        for second in {1..50}
        do
                echo -ne "${ANSI_CYAN_BACKGROUND} ${ANSI_RESET}"
                sleep ${SLEEP_INTERVAL}
        done

        echo -e "${ANSI_CYAN} READY${ANSI_RESET}"
}


# Pass in path to folder where Dockerfile lives
build () {
        print_dockerfile $1
        docker build -t $1 $1
}

cleanup () {
        docker rmi $1
}

suite_start () {
        echo -e "\n$ANSI_YELLOW_BACKGROUND$TEST_SUITE_START$ANSI_RESET \n"
}

suite_end () {
        echo -e "\n$ANSI_GREEN_BACKGROUND$TEST_SUITE_END$ANSI_RESET \n"
}


suite_start
        print_test_case "It starts, serves a web page, and is healthy:"
                build "sonarqube-with-curl"
                docker run --name healthy-sonarqube -d -p 9000:9000 "sonarqube-with-curl"
                wait_until_ready 10
                docker exec healthy-sonarqube curl --fail -X GET -I localhost:9000 | grep 200
                print_success "Success! Sonarqube is up and healthy."
                docker rm -f healthy-sonarqube
                cleanup "sonarqube-with-curl"
suite_end
