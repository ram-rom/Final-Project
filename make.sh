#!/bin/bash
# Check for pry. This can cause errors
if ! gem spec pry > /dev/null 2>&1; then
   gem install pry
fi
# Install SimpleScalar
./bin/ram-rom --install
# Compile SimpleScalar
./bin/ram-rom --compile
# Check for simpel-test completion
OUTPUT="$(./bin/ram-rom --simple-test perceptron | tail -1)"
if [ $OUTPUT != "Completed" ]; then
   echo "It looks like simple-test failed. Check the compiltation for errors and fix them."
   exit -1
fi
counter=0
# Run plan.yml files
for order in tests/configs/*; do
    $plan = 'plan_"$counter".yml'
    # Remove soft link for sim out of order file
    rm -rf simplescalar/simplesim-3.0/sim-outorder.c
    # Add link to current sim-outorder.c file
    ln $order simplescalar/simplesim-3.0/sim-outorder.c
    # Compile
    ./bin/ram-rom --compile
    # Check for simpel-test completion
    OUTPUT="$(./bin/ram-rom --simple-test perceptron | tail -1)"
    if [ $OUTPUT != "Completed" ]; then
        echo "It looks like simple-test failed. Check the compiltation for errors and fix them."
        exit -1
    fi
    ./bin/ram-rom --plan $plan
    let "counter++"
done
#Run analyze
./bin/ram-rom --analyze
