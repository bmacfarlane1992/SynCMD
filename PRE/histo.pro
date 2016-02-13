pro histo,tab1,mini,maxi,bin,abs=abs,cumul=cumul,overplot=overplot,$
xtitle=xtitle, ytitle=ytitle,xrange=xrange,yrange=yrange,title=title,help=help
;+
; FUNCTION: This procedure displays the histogram of 
;           the array tab1.
;
; INPUTS  : tab1 --> array
;         : mini --> minimum value 
;         : maxi --> maximum value 
;         : bin  --> size of bin 
;
; OUTPUTS : diplay
;
; keyword Input:
;           default   --> percentage 
;           /abs      --> compute the histogram in number of values
;           /cumul    --> compute the cumulative histogram 
;           /overplot --> overplot the histogram  
;           title     --> title of plot
;           xtitle    --> xtitle of plot
;           ytitle    --> ytitle of plot
;           xrange    --> xrange of plot
;           yrange    --> yrange of plot
;
; USE     : histo, array1,0,500,1, /cumul
;
; CONTACT : Didier JOURDAN   didier@esrg.ucsb.edu
;-
;
; compute histogram of the values
;
if keyword_set(help) then begin
  doc_library,'histo.pro'
  return
endif

hist=histogram(tab1,binsize=bin,min=mini,max=maxi)
;
ifin=n_elements(hist)
sum=fltarr(ifin)
;
; keyword abs active : number of values
;
if (keyword_set(abs) eq 0) then begin
  hist=float(hist)/total(hist)
  histunnorm=float(hist)*608330
endif
;
; keyword cumul active : cumulative histogram
;
if (keyword_set(cumul) ne 0) then begin
  for i=0,ifin-1 do begin
    sum(i)=total(hist(0:i))
  endfor
  hist=sum
endif
;
; set xtitle
;

if (keyword_set(xtitle) eq 0) then   xtitle=''
if (keyword_set(title) eq 0) then    title=''
;
; set ytitle
;
if (keyword_set(ytitle) eq 0) then begin
endif
;
; set yrange
;
if (keyword_set(yrange) eq 0) then begin
  ymax=max(hist)+max(hist)*.1
  yrange=[0,ymax]
endif
;
; set xrange
;
if (keyword_set(xrange) eq 0) then begin
  xrange=[mini,maxi]
endif

if (keyword_set(overplot) eq 0) then begin
;
; plot
;
  plot, findgen(ifin)*bin+mini+bin/2.,hist,psym=10, $
  ytitle=ytitle, xrange=xrange,yrange=yrange, xtitle=xtitle,title=title
openw,lun,'COMP_MDF_NORM.dat',/get_lun
printf,lun,hist
free_lun,lun
endif else begin;
; overplot
;
  oplot,hist,psym=10
endelse
return
end
