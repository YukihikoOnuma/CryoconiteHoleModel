#!/usr/bin/bash
sedf="t"

outDir="./out_stest"

expAr=('at' 'phi' 'd0' 'ai' 'ac' 'sr' 'kidf' 'kisf' 'zan' 'can')

atAr=('0.92' '1.92' '2.92' '4.92' '5.92' '6.92')
phiAr=('10' '30' '70' '90' '110' '130')
d0Ar=('0' '50' '100' '150' '200' '250')
aiAr=('0.3' '0.4' '0.5' '0.6' '0.7' '0.8')
acAr=('0.05' '0.15' '0.2' '0.25' '0.3' '0.35')
srAr=('2' '3' '1' '1' '1' '1')
kidfAr=('0.1' '0.25' '0.5' '2' '4' '10')
kisfAr=('0.1' '0.25' '0.5' '2' '4' '10')
zanAr=('0' '15' '30' '45' '60' '75')
canAr=('15' '30' '45' '60' '75' '90')

cd "../"

#=== exp loop
i=0
for exp in "${expAr[@]}"
do

  pFileO="./param/parameter.ini_2014_S2_v3_stest"
  pFileN="./parameter.ini"
  outFile="./ch_hourly.csv"
  echo "### $exp ###"
  echo $pFileO
  echo $pFileN
  echo $outFile

  p=0
  for stN in "${atAr[@]}"
  do

    if [ ${exp} = "ac" ]; then
      linef="6p"
      para=${acAr[$p]}
      linec="6c\ $para"
    elif [ ${exp} = "ai" ]; then
      linef="8p"
      para=${aiAr[$p]}
      linec="8c\ $para"
    elif [ ${exp} = "at" ]; then
      linef="10p"
      para=${atAr[$p]}
      linec="10c\ $para"
    elif [ ${exp} = "phi" ]; then
      linef="12p"
      para=${phiAr[$p]}
      linec="12c\ $para"
    elif [ ${exp} = "d0" ]; then
      linef="14p"
      para=${d0Ar[$p]}
      linec="14c\ $para"
    elif [ ${exp} = "sr" ]; then
      linef="22p"
      para=${srAr[$p]}
      linec="22c\ ${para}"
    elif [ ${exp} = "kidf" ]; then
      linef="26p"
      para=${kidfAr[$p]}
      linec="26c\ ${para}"
    elif [ ${exp} = "kisf" ]; then
      linef="28p"
      para=${kisfAr[$p]}
      linec="28c\ ${para}"
    elif [ ${exp} = "zan" ]; then
      linef="30p"
      para=${zanAr[$p]}
      linec="30c\ ${para}"
    elif [ ${exp} = "can" ]; then
      linef="32p"
      para=${canAr[$p]}
      linec="32c\ ${para}"
    fi

    if [ ${sedf} = "f" ]; then
      sed -n $linef $pFileN
      echo "$linec"  
      echo "->${para}"  
      echo "$outDir/ch_hourly_st_${exp}${para}.csv"

    elif [ ${sedf} = "t" ]; then
      cp $pFileO $pFileN
	sed -i "$linec" $pFileN
      ./a.out_stest
      mv $outFile "$outDir/ch_hourly_2014_st_${exp}${para}.csv"
    fi

    p=$(($p+1))
  done

  i=$(($i+1))
done

cd "./shell"
