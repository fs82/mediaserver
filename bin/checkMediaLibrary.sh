#!/bin/bash

# Counter for number of issues
issue=0
count=0

find . -mindepth 2 -maxdepth 3 -type d -print0 |
{
    while IFS= read -r -d '' dir; do
        ((count++))

        # Reset variables for loop
        str=""
        err=0

        # Check for whitespace in dir name
        if [[ `echo $dir | grep -c ".*\s.*"` -ne 0 ]]; then
            str="$str\n\tWhitespace in directory name"
            ((err++))
        fi

        # Check for whitespaces in file names
        if [[ `find "$dir" -maxdepth 1 -type f -name "*[[:space:]]*"` != "" ]]; then
            str="$str\n\tWhitespaces in file name"
            ((err++))
        fi

        if [[ $err -eq 0 ]]; then

            # Check for folder.jpg and cover.jpg
            if [ ! -f $dir/cover.jpg ] && [ ! -f $dir/folder.jpg ]; then
                str="$str\n\tNeither cover.jpg nor folder.jpg"
                ((err++))
            elif [ -f $dir/cover.jpg ] && [ ! -f $dir/folder.jpg ]; then
                cp $dir/cover.jpg $dir/folder.jpg
            elif [ ! -f $dir/cover.jpg ] && [ -f $dir/folder.jpg ]; then
                cp $dir/folder.jpg $dir/cover.jpg
            fi

            # Check for additional files
            files=$(find $dir -maxdepth 1 -type f ! \( -name cover.jpg -o -name folder.jpg \
                -o -name "*.flac" \
                -o -name "*.m4a" \
                -o -name "*.mp3" \))

            if [[ -n $files ]]; then
                for file in $files
                do
                    f=$(basename $file)
                    str="$str\n\tRemove $f"
                done
                ((err++))
            fi

        fi

        # In case no error was found display fine
        [[ -z $str ]] && str="is fine"

        # Summary for directory
        echo -e "Directory $dir $str"

        # Store err for global summary
        [[ $err -ne 0 ]] && ((issue++))
    done

    echo -e "\nSummary: Checked $count directories and found $issue issues"
}


