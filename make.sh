#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEST="${SCRIPT_DIR}/tests"

# Notify user that previous analysis and plans will be removed
echo "WARNING: Running this script will remove simplescalar directory, the plans and analyze folders, if they exist."
echo "Would you like to continue? Please enter y for yes or n for no followed by [ENTER]:"
read response

if [ "$response" != "y" ]; then
  echo "Ok, exiting script..."
  exit 0
fi

rm -rf $SCRIPT_DIR/simplescalar
rm -rf $SCRIPT_DIR/plans
rm -rf $SCRIPT_DIR/analyze

# install simple scalar
./bin/ram-rom --install

# Check for pry. This can cause errors
if ! gem spec pry > /dev/null 2>&1; then
   gem install pry
fi

# Check if user wants to run the short or long version
echo "Running the entire test plan can take quite a while. Would you like to run the full plan "
echo "or a shortened version of the plan? Please enter s for short or l for long followed by [ENTER]:"
read response

if [ "$response" == "s" ]; then
  # Remove soft link for sim out of order file
  rm -rf $SCRIPT_DIR/simplescalar/simplesim-3.0/sim-outorder.c
  # Add link to current sim-outorder.c file
  ln -s $TEST/test_src/sim-outorder-0.c $SCRIPT_DIR/simplescalar/simplesim-3.0/sim-outorder.c
  # Compile
  ./bin/ram-rom --compile
  # Check for simpel-test completion
  OUTPUT="$(./bin/ram-rom --simple-test perceptron | tail -1)"
  if [ $OUTPUT != "Completed" ]; then
      echo "It looks like simple-test failed. Check the compiltation for errors and fix them."
      exit -1
  fi
  echo "*** plan-0.yml ***"
  ./bin/ram-rom --plan tests/plan_files/plan-0.yml
elif [ "$response" == "l" ]; then
  counter=0
  # Run plan.yml files
  for order in tests/plan_files/*; do
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
    echo "*** $order ***"
    ./bin/ram-rom --plan $order
    let "counter++"
  done
else
  echo "Sorry that was not a valid option. Exiting..."
  exit 0
fi
#Run analyze
./bin/ram-rom --analyze

#Reset sim link
rm -rf $SCRIPT_DIR/simplescalar/simplesim-3.0/sim-outorder.c
ln -s $SCRIPT_DIR/src/sim-outorder.c $SCRIPT_DIR/simplescalar/simplesim-3.0/sim-outorder.c
