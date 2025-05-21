echo "Input of the first number"
read number1
echo "Input of the second number"
read number2

while [ $number1 -le $number2 ]
do
 echo "$number1"
 number1=$(($number1 + 1))
done
echo "Done, already done"
