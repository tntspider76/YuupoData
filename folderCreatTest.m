close all
clear
clearvars
fileName = 'global_50kmB_T150_Vsw200_fupper_fobs_output_inu'
TitleName = split(fileName,".")
namespilt = split(fileName,"_")
titleComp = [extract(namespilt(2),(digitsPattern(2)|digitsPattern(3))+"km"),extract(namespilt(4),digitsPattern(3))]
titleComp(1) = regexprep(titleComp(1), '(\d+)\s*km', '$1 km')

