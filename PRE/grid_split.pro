pro grid_split, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, stars=stars, hist_up=hist_up, $
	hist_down=hist_down, hist_int=hist_int, chem_gridup, chem_griddown, chem_gridint, help=help
;
; - - Procedure written to split the stellar distributions into associated bins, for analysis of:
; - - 		- [Fe/H] MDF
; - - 		- [Fe/H] vs. Age
; - - 		- [ [O,Mg]/Fe ] vs. [Fe/H]
; - - 		- [ [O,Mg]/Fe ] vs. Age
; - -		- [ [Fe,O,Mg]/ [H,Fe] ] vs. R_GC
; - - with min/max/increment values as defined within premain.pro
; 
; Author: Benjamin MacFarlane
; Date: 17/10/2014
; Contact: bmacfarlane@uclan.ac.uk
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
if (keyword_set(help) eq 1) then begin
   Message, 'Usage:',/info
   Message, 'grid_split, arch_dir, sim1, sim2, help=help', /info
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
hist_bins=fix((hist_up-hist_down)/hist_int)
print, hist_bins
dim1=['ofe','mgfe','feh']
dim2=['feh','age','r']
dim1point=[11,17,19]
dim2point=[19,8,4]
;
chem_gridup=1.
chem_griddown=-2.
chem_gridint=0.2
chem_gridnum=15
;
age_gridup=15
age_griddown=0
age_gridint=1
age_gridnum=15
;
r_gridup=15
r_griddown=0
r_gridint=0.5
r_gridnum=30
;
;
; - - -	MAIN PROGRAM - - - ;
;
; - - - Define the number of bins for each dim1 value
;
chem_bins=chem_gridnum
;
for i=0L, n_elements(dim1)-1 do begin
	print, 'Dimension 1: ', chem_bins, ' chemical bins'
	for j=0L, n_elements(dim2)-1 do begin
;
; - - - Define the filecount, fcount for array tags
;
		fcount=0
;
; - - - Ensure that matching abundance dimensions are not analysed
;
		if (dim1(i) eq dim2(j)) then continue
;
		spawn, 'mkdir '+arch_dir+'Inputs/'+dim1(i)+'_'+dim2(j)+'/'
;
; - - - Define the number of bins for dimension 2
;
		case dim2(j) of
			'feh': begin
				dim2_bins=chem_gridnum
				print, 'Dimension 2: ', dim2_bins, ' chemical bins'
			       end
			'age': begin
				dim2_bins=age_gridnum
				print, 'Dimension 2: ', dim2_bins, ' age bins'
			       end
			'r': begin
				dim2_bins=r_gridnum
				print, 'Dimension 2: ', dim2_bins, ' radial bins'
			     end 
		endcase
;
		print, 'The abundance analysis will be: ', dim1(i), '   vs.   ',  dim2(j)
		print, 'The number of bins to be output is: ', chem_bins*dim2_bins
;
; - - - Begin looping over dimesions to restrict and populate bins with composite particles
; - - - For 2D data. With 2D loop, incrementally increase fcount for integer tag of grid point.
;
		for m=0, chem_bins-1 do begin
;			print, (m*chem_gridint)+chem_griddown, ((m+1)*chem_gridint)+chem_griddown
			for n=0, dim2_bins-1 do begin
				fcount=fcount+1
;				print, m, n, (m*dim2_bins(j)+n)
;				print, 'dim1 limits: ', (m*chem_gridint)+chem_griddown, '  ', ((m+1)*chem_gridint)+chem_griddown
;				print, 'dim2 limits: ', (n*chem_gridint)+chem_griddown, '  ', ((n+1)*chem_gridint)+chem_griddown
				count=0
				case dim2(j) of
					'feh':	begin
						gridbin=where((stars(dim1point(i),*) gt ((m)*chem_gridint)+chem_griddown) AND $
						(stars(dim1point(i),*) lt ((m+1)*chem_gridint)+chem_griddown) AND $
						(stars(dim2point(j),*) gt ((n)*chem_gridint)+chem_griddown) AND $
						(stars(dim2point(j),*) lt ((n+1)*chem_gridint)+chem_griddown), count)
					        count=count
					       end
					'age':  begin
						gridbin=where((stars(dim1point(i),*) gt ((m)*chem_gridint)+chem_griddown) AND $
						(stars(dim1point(i),*) lt ((m+1)*chem_gridint)+chem_griddown) AND $
						(stars(dim2point(j),*) gt ((n)*age_gridint)+age_griddown) AND $
						(stars(dim2point(j),*) lt ((n+1)*age_gridint)+age_griddown), count)
						count=count
					       end
					'r':   begin
						gridbin=where((stars(dim1point(i),*) gt ((m)*chem_gridint)+chem_griddown) AND $
						(stars(dim1point(i),*) lt ((m+1)*chem_gridint)+chem_griddown) AND $
						(stars(dim2point(j),*) gt ((n)*r_gridint)+r_griddown) AND $
						(stars(dim2point(j),*) lt ((n+1)*r_gridint)+r_griddown), count)
						count=count
					       end
				endcase 
;
; - - - Print data when grid bin has count =/= 0
; - - - Also provide file with filecount association for grid pointer, fcount.
;
				if (count ne 0) and (count gt 0) then begin
					gridarray=fltarr(26,count)
					gridarray(0,*)=stars(0,[gridbin])
					gridarray(1,*)=stars(1,[gridbin])
					gridarray(2,*)=stars(2,[gridbin])
					gridarray(3,*)=stars(3,[gridbin])
					gridarray(4,*)=stars(4,[gridbin])
					gridarray(5,*)=stars(5,[gridbin])
					gridarray(6,*)=stars(6,[gridbin])
					gridarray(7,*)=stars(7,[gridbin])
					gridarray(8,*)=stars(8,[gridbin])
					gridarray(9,*)=stars(9,[gridbin])
					gridarray(10,*)=stars(10,[gridbin])
					gridarray(11,*)=stars(11,[gridbin])
					gridarray(12,*)=stars(12,[gridbin])
					gridarray(13,*)=stars(13,[gridbin])
					gridarray(14,*)=stars(14,[gridbin])
					gridarray(15,*)=stars(15,[gridbin])
					gridarray(16,*)=stars(16,[gridbin])
					gridarray(17,*)=stars(17,[gridbin])
					gridarray(18,*)=stars(18,[gridbin])
					gridarray(19,*)=stars(19,[gridbin])
					gridarray(20,*)=stars(20,[gridbin])
					gridarray(21,*)=stars(21,[gridbin])
					gridarray(22,*)=stars(22,[gridbin])
					gridarray(23,*)=stars(23,[gridbin])
					gridarray(24,*)=stars(24,[gridbin])
					gridarray(25,*)=stars(25,[gridbin])
;
; - - - Print data when grid bin has count =/= 0
; - - - Also provide file with filecount association for grid pointer.
;
					filename=arch_dir+'Inputs/'+dim1(i)+'_'+dim2(j)+'/'+dim1(i)+'_'+dim2(j)+'_'+sim1+sim2+'_'+tag+'_'+strcompress(fcount,/remove_all)+'.dat'
					openw,lun,filename,/get_lun
					printf,lun, gridarray
					free_lun, lun
				endif
;
				if (count eq 0) AND (count lt 1) then begin
					gridarray=fltarr(26,1)
					gridarray(0,*)=0
;
; - - - Print blank data file when grid bin has count == 0
; - - - Provide grid pointer as with count =/= 0
;
					filename=arch_dir+'Inputs/'+dim1(i)+'_'+dim2(j)+'/'+dim1(i)+'_'+dim2(j)+'_'+sim1+sim2+'_'+tag+'_'+strcompress(fcount,/remove_all)+'.dat'
					openw,lun,filename,/get_lun
					printf, lun, ''
					free_lun, lun	 
				endif
;
; - - - close n'th restriction loop (dim2)
			endfor
; - - - close m'th restriction loop (dim1)
		endfor
; - - - close jth dimesion loop (dim2)
	endfor	
; - - - close i'th dimension loop (dim1)
endfor
;
;
end
