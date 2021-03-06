pro mdf_split, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, stars=stars, hist_up=hist_up, $
	hist_down=hist_down, hist_int=hist_int, help=help
;
; - - Procedure written to split the stellar distributions into equally spaced histogram bins,
; - - with min/max/increment values as defined within premain.pro
; 
; Author: Benjamin MacFarlane
; Date: 7/02/2016
; Contact: bmacfarlane@uclan.ac.uk
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
if (keyword_set(help) eq 1) then begin
   Message, 'Usage:',/info
   Message, 'select, arch_dir, sim1, sim2, help=help', /info
   Message, 'Purpose: Read simulation required by user, and find ', /info
   Message, '         file to which SynCMD runs over', /info
   Message, 'Input:   arch_dir = Directory source for SynCMD', /info
   Message, '	      sim1 = Simulation to be used (MUGS or MaGICC)', /info
   Message, '	      sim2 = Simulation iteration to be used (g1536 or g15784)', /info
   Message, 'Outputs: No returned values into premain.pro - MDF specific', /info
   Message, '	      stellar distributions are printed to $arch$/Inputs/MDF', /info
   return
endif
;
;
; - - - VARIABLE DEFINITIONS - - - ;
;
dim1=['ofe','mgfe','feh','age']
dim1point=[11,17,19,8]
;
agehist_up = 15.
agehist_down = 0.
agehist_int = 1
;
; - - -	MAIN PROGRAM - - - ;
;
;
nbins=floor((hist_up-hist_down)/hist_int)
;
for c=0L, n_elements(dim1)-1 do begin
	print, 'MDF for: ', dim1,' dimension'
	spawn, 'mkdir '+arch_dir+'Inputs/'+dim1(c)+'_mdf/';
;
	if (dim1(c) eq 'age') then begin
		hist_down = agehist_down
		hist_up = agehist_up
		hist_int = agehist_int
		nbins = (agehist_up - agehist_down)/agehist_int
	endif
; 
	for i=0, nbins-1 do begin
		bin=where((stars(dim1point(c),*) gt ((i)*hist_int)+hist_down) AND $
			(stars(dim1point(c),*) lt ((i+1)*hist_int)+hist_down), count)
			count=count
;
		dum=0
		if (count eq 0) then begin
			filename=arch_dir+'Inputs/'+dim1(c)+'_mdf/'+dim1(c)+'_mdf_'+sim1+sim2+'_'+tag+ $
				'_'+strcompress((i+1),/remove_all)+'.dat'
			openw,lun,filename,/get_lun
			printf,lun, dum
			free_lun, lun
		endif		
;
		if (count ne 0) then begin
			binarray=fltarr(26,count)
			binarray(0,*)=stars(0,[bin])
			binarray(1,*)=stars(1,[bin])
			binarray(2,*)=stars(2,[bin])
			binarray(3,*)=stars(3,[bin])
			binarray(4,*)=stars(4,[bin])
			binarray(5,*)=stars(5,[bin])
			binarray(6,*)=stars(6,[bin])
			binarray(7,*)=stars(7,[bin])
			binarray(8,*)=stars(8,[bin])
			binarray(9,*)=stars(9,[bin])
			binarray(10,*)=stars(10,[bin])
			binarray(11,*)=stars(11,[bin])
			binarray(12,*)=stars(12,[bin])
			binarray(13,*)=stars(13,[bin])
			binarray(14,*)=stars(14,[bin])
			binarray(15,*)=stars(15,[bin])
			binarray(16,*)=stars(16,[bin])
			binarray(17,*)=stars(17,[bin])
			binarray(18,*)=stars(18,[bin])
			binarray(19,*)=stars(19,[bin])
			binarray(20,*)=stars(20,[bin])
			binarray(21,*)=stars(21,[bin])
			binarray(22,*)=stars(22,[bin])
			binarray(23,*)=stars(23,[bin])
			binarray(24,*)=stars(24,[bin])
			binarray(25,*)=stars(25,[bin])
;
			filename=arch_dir+'Inputs/'+dim1(c)+'_mdf/'+dim1(c)+'_mdf_'+sim1+sim2+'_'+tag+ $
				'_'+strcompress((i+1),/remove_all)+'.dat'
			openw,lun,filename,/get_lun
			printf,lun, binarray
			free_lun, lun
		endif
	endfor
endfor
;
;
end


