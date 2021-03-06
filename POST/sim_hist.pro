pro sim_hist, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, hist_up=hist_up, $
	hist_down=hist_down, hist_int=hist_int, count_stars=count_stars, simhist_dat, stat_sim, help=help
;
; - - Procedure written to determine histogram values within limits as determined within
; - - premain.pro, for simulation stellar populations
;
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
;
;
if (keyword_set(help) eq 1) then begin
   Message, 'Usage:',/info
   Message, 'sim_hist, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag,', /info
   Message, 'hist_up=hist_up, hist_down=hist_down, hist_int=hist_int,', /info
   Message, 'simhist_dat', /info
   Message, 'Purpose: Determine histogram values of simulation within ', /info
   Message, '         [Fe/H] range defined within premain.pro', /info
   Message, 'Input:   arch_dir = Directory in which SynCMD package stored', /info
   Message, '	      sim1 = Simulation used ([MaGICC, MUGS])', /info
   Message, '	      sim2 = Simulation iteration used ([g1536, g15784])', /info
   Message, '	      tag = SynCMD run tag association', /info
   Message, '	      hist_$i$ ($i$=[up, down, int]) = Histogram parameters to', /info
   Message, '	      to be utiltised within both simulation and synthetic analyses', /info
   Message, '	      count_stars =  Number of restricted simulation stellar particles', /info
   Message, 'Outputs: sim_hist = Histogram data for use in', /info
   Message, '	      comparison analyses', /info
   Message, '	      stat_sim = unnormalised histogram data for use within', /info
   Message, '	      statistic determination', /info
   return
endif
;
;
	; - - - VARIABLE DEFINITIONS - - - ;
;
;
;
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
;
;
; - - -	MAIN PROGRAM - - - ;
;
;
	; - - - First read simulation [Fe/H] data for prescribed simulation variables (premain.pro)
;
feh=fltarr(count_stars(0))
age=fltarr(count_stars(0))
filein=arch_dir+'Inputs/CMDSTARS'+sim1+sim2+'_'+tag+'.dat'
openr,lun,filein,/get_lun
for i=0L, count_stars(0)-1 do begin
	readf, lun, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10, tmp11, tmp12, $
		tmp13, tmp14, tmp15, tmp16, tmp17, tmp18, tmp19, tmp20, tmp21, tmp22, tmp23, $
		tmp24,tmp25,tmp26
	age(i)=tmp9
	feh(i)=tmp20
endfor
free_lun, lun
;
	; - - - Count the NORMALISED number of particles within a metallicity bin
;
hist_num=(hist_up(0)-hist_down(0))/hist_int(0)
simhist_dat=fltarr(hist_num(0))
stat_sim=fltarr(hist_num(0))
;
for i=0, hist_num(0)-1 do begin
  binpop=where((feh gt hist_down(0)+(hist_int(0)*i)) AND (feh lt hist_down(0)+(hist_int(0)*(i+1))))
  simhist_dat(i)=n_elements(binpop)-1
  stat_sim(i)=simhist_dat(i)
  simhist_dat(i)=simhist_dat(i)/count_stars(0)
endfor
;
;
end
