echo "Please enter the name of the document:"
read namedocument
if [ -e $namedocument]
then
echo "document exists"
else
echo "document doesn't exists"
fi
