# CPATH variable to store the classpath for compilation and execution
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

# removes previous student submission
rm -rf student-submission 

# removes previous grading area
rm -rf grading-area 

# creates new grading area
mkdir grading-area 

# clones student submission into student-submission folder
# git clone https://github.com/ucsd-cse15l-f22/list-methods-lab3
git clone $1 student-submission
echo 'Finished cloning'

# checks whether the submissions are sufficient?
if [[ -f student-submission/ListExamples.java ]]; then
    echo "ListExamples.java found"
else
    echo "ListExamples.java not found in submission"
    echo "Score: 0/4"
    exit 1
fi

# copies the .java files from the student-submission into the grading-area
cp -r student-submission/*.java ./grading-area
cp -r ./lib ./grading-area
cp -r ./TestListExamples.java ./grading-area

# echo `ls ./grading-area`

# Signifies that it was copied
if [[ -f grading-area/ListExamples.java ]] && [[ -d grading-area/lib ]] && [[ -f grading-area/TestListExamples.java ]]; then
    echo "Finished copying"
else
    echo "Error in moving the files"
    echo "Score: 0/4"
    exit 1
fi

# compiles the .java files in the grading-area -> error: backslash
set +e 
cd grading-area
javac -cp $CPATH *.java
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > ../junit-output.txt
cd ../

# checks whether the junit-output.txt file was created
if [[ -f junit-output.txt ]]; then
    echo "JUnit output file created successfully."
else
    echo "JUnit output file not created"
    exit 1
fi

# checks whether the compilation was successful (not sure if this counts right)
FAILURES=`grep -c "FAILURES\!\!\!" junit-output.txt`

if [[ $FAILURES -eq 0 ]]; then
    echo "Compilation successful: 4/4"
else
    RESULT_LINE=`grep "Tests run:" junit-output.txt`
    COUNT=${RESULT_LINE:25:1}

    echo ""
    echo "JUnit output was:"
    cat junit-output.txt
    echo " Score: $COUNT/4 "
    echo ""
fi