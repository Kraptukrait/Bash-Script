echo "Please enter a folder name:"
read foldername
content=$(ls -l $foldername | wc -l)
echo $content
