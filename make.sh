#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEST="${SCRIPT_DIR}/tests"

# Notify user that previous analysis and plans will be removed
echo "WARNING: Running this script will remove the plans and analyze folders, if they exist."
echo "Would you like to continue? Please enter y for yes or n for no followed by [ENTER]:"
read response

if [ "$response" != "y" ]; then
  echo "Ok, exiting script..."
  exit 0
fi

rm -rf $SCRIPT_DIR/plans
rm -rf $SCRIPT_DIR/analyze

# Check for pry. This can cause errors
if ! gem spec pry > /dev/null 2>&1; then
   gem install pry
fi
counter=0
# Run plan.yml files
for order in tests/plans/*; do
    # Remove soft link for sim out of order file
    rm -rf $SCRIPT_DIR/simplescalar/simplesim-3.0/sim-outorder.c
    # Add link to current sim-outorder.c file
    ln -s $TEST/test_src/sim-outorder-$counter.c $SCRIPT_DIR/simplescalar/simplesim-3.0/sim-outorder.c
    # Compile
    ./bin/ram-rom --compile
    # Check for simpel-test completion
    OUTPUT="$(./bin/ram-rom --simple-test perceptron | tail -1)"
    if [ $OUTPUT != "Completed" ]; then
        echo "It looks like simple-test failed. Check the compiltation for errors and fix them."
        exit -1
    fi
    ./bin/ram-rom --plan $order
    let "counter++"
done
#Run analyze
./bin/ram-rom --analyze

#Reset sim link
ln -s $SCRIPT_DIR/src/sim-outorder.c $SCRIPT_DIR/simplescalar/simplesim-3.0/sim-outorder.c
