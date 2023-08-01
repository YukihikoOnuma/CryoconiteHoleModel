#!/usr/bin/bash
sedf="t"

inDir="./param"
outDir="./out_cal_obs"

expAr=(2012 2014 2014 2014 2014 2017 2017 2017)
pFileOAr=('parameter.ini_2012_S3_v3' 'parameter.ini_2014_S1_v3' 'parameter.ini_2014_S2_v3' 'parameter.ini_2014_S3_v3' 'parameter.ini_2014_S4_v3' 'parameter.ini_2017_S1_v3' 'parameter.ini_2017_S2_v3' 'parameter.ini_2017_S3_v3')

aiMinAr=('0.33' '0.65' '0.54' '0.33' '0.33' '0.45' '0.38' '0.18')
aiMaxAr=('0.47' '0.71' '0.60' '0.47' '0.49' '0.67' '0.46' '0.30')

cd "../"

#=== exp loop
i=0
for exp in "${expAr[@]}"
do

  pFileO="${inDir}/${pFileOAr[$i]}"
  pFileN="./parameter.ini"
  #outFile="./ch_hourly.csv"
  echo "### $exp ###"
  echo $pFileO
  #echo $pFileN
  cp $pFileO $pFileN

  outFile_ori=`sed -n 2p $pFileN`
  outFile_ori="${outFile_ori:0:-5}.csv"

  outFile_min=`sed -n 2p $pFileN`
  linef_min="8p"
  para_min=${aiMinAr[$i]}
  linec_min="8c\ $para_min"
  outFile_min="${outFile_min:0:-7}${para_min:2:4}.csv"

  outFile_max=`sed -n 2p $pFileN`
  linef_max="8p"
  para_max=${aiMaxAr[$i]}
  linec_max="8c\ $para_max"
  outFile_max="${outFile_max:0:-7}${para_max:2:4}.csv"
  echo $outFile_ori
  echo $outFile_min
  echo $outFile_max

  if [ ${sedf} = "f" ]; then
    sed -n $linef_min $pFileN
    echo "$linec_min"  
    echo "->${para_min}"  
    echo "$outDir/${outFile_min}"

    sed -n $linef_max $pFileN
    echo "$linec_max"  
    echo "->${para_max}"  
    echo "$outDir/${outFile_max}"

  elif [ ${sedf} = "t" ]; then
    ./a.out
    mv "./$outFile_ori" "$outDir/$outFile_ori"

    sed -i "$linec_min" $pFileN
    ./a.out
    mv "./$outFile_ori" "$outDir/$outFile_min"

    sed -i "$linec_max" $pFileN
    ./a.out
    mv "./$outFile_ori" "$outDir/$outFile_max"
  fi

  i=$(($i+1))
done

cd "./shell"
