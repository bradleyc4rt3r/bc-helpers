#!/bin/bash
set -x

cd /home/spleeter/spleeter
zip -r split_output.zip audio_output/

cat <<EOF > tmp.mail
<h1>Swansea DJ Society - Track Splitter</h1>
Please open the link to a zip file of the tune split into it's components!<br>
<br>
There are many FUTURE CHANGES to come such as: batch-processing, number of stem choice, multi file-type input and actually now I come to think about it quite a bit more..<br>
Kind regards,<br><br>
Swansea Universities DJ Society<br><br>
Tel: 07496479569<br>
Email: dj@swansea-societies.co.ukbr>
Web: www.su-djsoc.co.uk<br
><br>
EOF

cat tmp.mail | mutt -e 'set content_type="text/html"' "bradleyc4rt3r@gmail.com" -b "bradleyc4rt3r@gmail.com" -s "Swansea Uni DJ Society - Track Splitter" -e 'my_hdr From: Swansea Uni DJ Society <dj@swansea-societies.co.uk>' -e 'set from=dj@swansea-societies.co.uk' -a split_output.zip

rm -f split_output.zip
set +x
