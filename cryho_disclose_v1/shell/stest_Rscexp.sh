#!/usr/bin/bash
sedf="t"

outDir="./out_stest_Rscexp"

expAr=('Rscphi' 'Rscd')

phiAr=('10' '30' '50' '70' '90' '110' '130' '150')
dAr=('10' '50' '100' '150' '200' '250' '300' '350')

cd "../"

#=== Site loop
i=0
for exp in "${expAr[@]}"
do

  pFileO="./param/parameter.ini_2014_S2_v3_Rscexp"
  pFileN="./parameter.ini"
  outFile="./ch_hourly.csv"
  echo "### $exp ###"
  echo $pFileO
  echo $pFileN
  echo $outFile

  p=0
  for stN in "${phiAr[@]}"
  do

    if [ ${exp} = "Rscphi" ]; then
      linef="12p"
      para=${phiAr[$p]}
      linec="12c\ $para"
    elif [ ${exp} = "Rscd" ]; then
      linef="14p"
      para=${dAr[$p]}
      linec="14c\ $para"
    fi

    if [ ${sedf} = "f" ]; then
      sed -n $linef $pFileN
      echo "$linec"  
      echo "->${para}"  
      echo "$outDir/ch_hourly_st_${exp}${para}.csv"

    elif [ ${sedf} = "t" ]; then
      cp $pFileO $pFileN
      sed -i "$linec" $pFileN
      ./a.out_RscexpLT01
      mv $outFile "$outDir/ch_hourly_2014_st_${exp}${para}_LT01.csv"
      ./a.out_RscexpLT13
      mv $outFile "$outDir/ch_hourly_2014_st_${exp}${para}_LT13.csv"
    fi

    p=$(($p+1))
  done

  i=$(($i+1))
done

cd "./shell"
