ase_0="1.0.2";ase_1=navigator.userAgent.toLowerCase();ase_2=(ase_1.indexOf('gecko')!=-1&&ase_1.indexOf('safari')==-1);ase_3=(ase_1.indexOf('konqueror')!=-1);ase_4=(ase_1.indexOf('chrome')!=-1);ase_5=(ase_1.indexOf('safari')!=-1)&&!ase_4;ase_6=(ase_1.indexOf('opera')!=-1);ase_7=(ase_1.indexOf('msie')!=-1&&!ase_6&&(ase_1.indexOf('webtv')==-1));ase_8=ase_7?-2:0;function ase_9(){return(new RegExp("msie ([0-9]{1,}[\.0-9]{0,})").exec(ase_1)!=null)?parseFloat(RegExp.$1):6.0;}
function ase_a(){return(new RegExp("firefox[\\/\\s](\\d+\\.\\d+)").exec(ase_1)!=null)?parseFloat(RegExp.$1):2.0;}
function ase_b(id){return document.getElementById?document.getElementById(id):document.all[id];}
function ase_c(e,lb,lc,ld,le){if(e&&(typeof(e[ld])!='undefined'))return e[ld];if(window.event)return window.event[lb]+((document.documentElement&&document.documentElement[lc])||document.body[lc]);else return e[lb]+window[le];}
function ase_d(e){return ase_c(e,"clientX","scrollLeft","pageX","scrollX")+ase_8;}
function ase_e(e){return ase_c(e,"clientY","scrollTop","pageY","scrollY")+ase_8;}
function ase_f(e){if(ase_7&&window.event)return window.event.button;else return(e.which==3)?2:e.which;}
function ase_g(lf,lg){return lf?lf[lg]+ase_g(lf.offsetParent,lg):0;}
function ase_h(lf,lg){if((!ase_6)&&lf&&(lf!=document.body)&&(lf!=document.documentElement))return lf[lg]+ase_h(lf.parentNode,lg);else return 0;}
function ase_i(lf){return ase_g(lf,"offsetLeft")-ase_h(lf,"scrollLeft")+(lf.offsetWidth-lf.clientWidth)/2;}
function ase_j(lf){return ase_g(lf,"offsetTop")-ase_h(lf,"scrollTop")+(lf.offsetHeight-lf.clientHeight)/2;}
function ase_k(lh,li){return lh+((lh.indexOf('?')!=-1)?'&':'?')+li;}
function ase_l(lj,lk,ll){var re=new RegExp(lk,'g');return lj.replace(re,ll);}
function ase_m(ln){var lo=document.scripts;if(((!lo)||(!lo.length))&&document.getElementsByTagName)lo=document.getElementsByTagName("script");if(lo){for(var i=0;i<lo.length;++i){var lq=lo[i].src;if(!lq)continue;var lr=lq.indexOf(ln);if(lr!=-1)return lq.substring(0,lr);}
}
return "";}
function ase_n(ls,lt,lu){var lv=ls.indexOf(lt);var lw=ls.indexOf(lu);if((lv<0)||(lw<=lv))return '';else return ls.substring(lv+lt.length,lw);}
function ase_o(ls,lx){var lr=ls.indexOf(lx);return(lr>=0)?ls.substring(0,lr):ls;}
function ase_p(ls,lx){var lr=ls.indexOf(lx);return(lr>=0)?ls.substring(lr+1,ls.length):"";}
function ase_q(v){return ase_l(ase_l(v,'&','&amp;'),'"','&#34;');}
function ase_r(n){n.onload=n.onerror='';n.src='javascript:;';var p=n.parentNode||n.parentElement;if(p&&p.removeChild)p.removeChild(n);else if(n.outerHTML)n.outerHTML='';}
function ase_s(f){var f2=frames[f.id];if(f2){var d2=f2.contentDocument||f2.document;if(d2)return d2.body.innerHTML;}
return null;}
function ase_AJAX_frame_loaded(f){if(f.lx1)return;var l41=ase_s(f);if(null!=l41)f.lh1(l41);ase_r(f);}
function ase_AJAX_frame_error(f){if(f.li1)f.li1(700,ase_s(f));ase_r(f);}
function ase_t(lh,l51,l61){var f=null;var l71="ase_AJAX_frame_"+(new Date().getTime());if(ase_7&&(ase_9()>=5.5)){document.body.insertAdjacentHTML('AfterBegin',"<IFRAME SRC='javascript:;' NAME='"+l71+"' ID='"+l71+"' style='display:none' onload='ase_AJAX_frame_loaded(this)' onerror='ase_AJAX_frame_error(this)'></IFRAME>");f=ase_b(l71);}
if(!f){if(l61)l61(600,"Cannot create IFRAME '"+l71+"'");return null;}
var f2=frames[f.id];var d2=f2.contentDocument||f2.document;f.lx1=true;d2.open();d2.write('<html><body><form name="ase_form" method="'+((lh.length<1000)?'get':'post')+'" action="'+ase_q(ase_o(lh,"?"))+'">');var l81=ase_p(lh,"?").split("&");for(var i=0;i<l81.length;++i){d2.write('<input type="hidden" name="'+ase_q(ase_o(l81[i],"="))+'" value="'+ase_q(unescape(ase_p(l81[i],"=")))+'">');}
d2.write('</form></body></html>');d2.close();f.lx1=false;f.lh1=l51;f.li1=l61;d2.forms['ase_form'].submit();return{'abort':function(){ase_r(f);}};}
function ase_u(){if(typeof XMLHttpRequest!='undefined')return new XMLHttpRequest();
/*@cc_on
@if(@_jscript_version>=5)
try{return new ActiveXObject("Msxml2.XMLHTTP");}catch(e){}
try{return new ActiveXObject("Microsoft.XMLHTTP");}catch(e){}
@end
@*/
}
function ase_v(lh,l51,l61){var r=ase_u();if(r){r.onreadystatechange=function(){if(r.readyState==4){var status=-9999;eval("try { status = r.status; } catch(e) {}");if(status==-9999)return;if((r.status==200)||(r.status==304))l51(r.responseText);else if(l61)l61(r.status,r.responseText);window.setTimeout(function(){r.onreadystatechange=function(){};r.abort();},1);}
}
if((lh.length<1000)||(ase_6&&!r.setRequestHeader)){r.open('GET',lh,true);r.send(null);}
else {r.open('POST',ase_o(lh,"?"),true);r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");r.send(ase_p(lh,"?"));}
return r;}
return ase_t(lh,l51,l61);}
function _jcv(v){this.lr=v.id;v.lc2=v.useMap;this.lp1=v.style.cursor;this.lr1(v);this.lo={};var lb1=v.id+"_JsChartViewerState";this.lu1=ase_b(lb1);if(!this.lu1){var p=v.parentNode||v.parentElement;if(p&&p.insertBefore){var s=this.lu1=document.createElement("HIDDEN");s.id=s.name=lb1;s.value=this.la1();p.insertBefore(s,v);}
else if(v.insertAdjacentHTML){v.insertAdjacentHTML("AfterEnd","<HIDDEN id='"+lb1+"' name='"+lb1+"'>");this.lu1=ase_b(lb1);if(this.lu1)this.lu1.value=this.la1();else this.lu1={"name":lb1,"id":lb1,"value":this.la1()};}
}
else this.decodeState(this.lu1.value);this.ls1();if(!ase_7)this.l11(this.lw1());if(this.ln)this.partialUpdate();}
_jcvp=_jcv.prototype;_jcv.l22=function(le1){var lf1=window.cdjcv_path;if(typeof lf1=="undefined")lf1=ase_m("cdjcv.js");else if((lf1.length>0)&&("/=".indexOf(lf1.charAt(lf1.length-1))==-1))lf1+='/';return lf1+le1;}
_jcv.Horizontal=0;_jcv.Vertical=1;_jcv.HorizontalVertical=2;_jcv.Default=0;_jcv.Scroll=2;_jcv.ZoomIn=3;_jcv.ZoomOut=4;_jcv.msgContainer='<div style="font-family:Verdana;font-size:8pt;font-weight:bold;padding:3 8 3 8;border:1pt solid #000000;background-color:#FFCCCC;color:#000000">%msg</div>';_jcv.okButton='<center>[<a href="javascript:%closeScript"> OK </a>]</center>';_jcv.xButton='[<a href="javascript:%closeScript"> X </a>]';_jcv.shortErrorMsg='Error %errCode accessing server'+_jcv.okButton;_jcv.serverErrorMsg=_jcv.xButton+'<div style="font-family:Arial; font-weight:bold; font-size:15pt;">Error %errCode accessing server</div><hr>%errMsg';_jcv.updatingMsg='<div style="padding:0 8 0 6;background-color:#FFFFCC;color:#000000;border:1px solid #000000"><table><tr><td><img src="'+_jcv.l22('wait.gif')+'"></td><td style="font-size:8pt;font-weight:bold;font-family:Verdana">Updating</td></tr></table></div>';_jcv.lj1=new Array("l0","l1","l2","l3","l4","l5","l6","l7","l8","l9","la","lb","lc","ld","le","lf","lg","lh","li","lj","lk","ll","lm","ln","lo","lp","lq");_jcv.get=function(id){var imgObj=ase_b(id);if(!imgObj)return null;if(!imgObj._jcv)imgObj._jcv=new _jcv(imgObj);return imgObj._jcv;}
_jcvp.getId=function(){return this.lr;}
_jcvp.lt1=function(){return ase_b(this.lr);}
_jcvp.lr1=function(){this.lt1().ly=function(e,id){var lh1;if(!this._jcv.lm1)lh1=this._jcv["onImg"+id](e);if(this["_jcvOn"+id+"Chain"])lh1=this["_jcvOn"+id+"Chain"](e);return lh1;};this.lt1()._jcvOnMouseMoveChain=this.lt1().onmousemove;this.lt1()._jcvOnMouseUpChain=this.lt1().onmouseup;this.lt1()._jcvOnMouseDownChain=this.lt1().onmousedown;var li1=this.lr;this.lt1().onmousemove=function(e){return ase_b(li1).ly(e,"MouseMove");}
this.lt1().onmousedown=function(e){return ase_b(li1).ly(e,"MouseDown");}
this.lt1().onmouseup=function(e){return ase_b(li1).ly(e,"MouseUp");}
}
_jcvp.lq2=function(x){return x-ase_i(this.lt1());}
_jcvp.lr2=function(y){return y-ase_j(this.lt1());}
_jcvp.lp2=function(w){return w;}
_jcvp.lo2=function(h){return h;}
_jcvp.lm2=function(x){return x+ase_i(this.lt1());}
_jcvp.ln2=function(y){return y+ase_j(this.lt1());}
_jcvp.ll2=function(w){return w;}
_jcvp.lk2=function(h){return h;}
_jcvp.setCustomAttr=function(k,v){this.lo[k]=v;this.le2();}
_jcvp.getCustomAttr=function(k){return this.lo[k];}
_jcvp.l4=0;_jcvp.l5=0;_jcvp.l6=1;_jcvp.l7=1;_jcvp.setViewPortLeft=function(x){this.l4=x;this.le2();}
_jcvp.getViewPortLeft=function(){return this.l4;}
_jcvp.setViewPortTop=function(y){this.l5=y;this.le2();}
_jcvp.getViewPortTop=function(){return this.l5;}
_jcvp.setViewPortWidth=function(w){this.l6=w;this.le2();}
_jcvp.getViewPortWidth=function(){return this.l6;}
_jcvp.setViewPortHeight=function(h){this.l7=h;this.le2();}
_jcvp.getViewPortHeight=function(){return this.l7;}
_jcvp.l0=-1;_jcvp.l1=-1;_jcvp.l2=-1;_jcvp.l3=-1;_jcvp.l01=function(x,y){x=this.lq2(x);y=this.lr2(y);return(this.l0<=x)&&(x<=this.l0+this.l2)&&(this.l1<=y)&&(y<=this.l1+this.l3);}
_jcvp.msgBox=function(lo1,lp1){var m=this.l21;if(!m&&lo1){var d=document;if(d.body.insertAdjacentHTML){var ls1='msg_'+this.lr;d.body.insertAdjacentHTML("BeforeEnd","<DIV ID='"+ls1+"' style='position:absolute;visibility:hidden;'></DIV>");m=ase_b(ls1);}
else if(d.createElement){m=d.createElement("DIV");m.style.position='absolute';m.style.visibility='hidden';d.body.appendChild(m);}
if(m)this.l21=m;}
if(m){window.clearTimeout(m.l31);var s=m.style;if(lo1){if(lp1)m.l31=window.setTimeout(function(){s.visibility='hidden';},Math.abs(lp1));if(lp1<0)lo1+=_jcv.okButton;if(lo1.substring(0,4).toLowerCase()!="<div")lo1=ase_l(_jcv.msgContainer,'%msg',lo1);var lt1="_jcv.get('"+this.lr+"').msgBox();";m.innerHTML=ase_l(lo1,'%closeScript',lt1);s.visibility='visible';s.left=this.lm2(Math.max(0,this.l0+(this.l2-m.offsetWidth)/2))+"px";s.top=this.ln2(Math.max(0,this.l1+(this.l3-m.offsetHeight)/2))+"px";}
else {s.visibility='hidden';}
}
}
_jcvp.l8=2;_jcvp.l9="#000000";_jcvp.setSelectionBorderWidth=function(w){this.l8=w;this.le2();}
_jcvp.getSelectionBorderWidth=function(){return this.l8;}
_jcvp.setSelectionBorderColor=function(c){this.l9=c;this.le2();}
_jcvp.getSelectionBorderColor=function(){return this.l9;}
_jcvp.lq1=function(){_jcv.l92=this.l62("_jcv_leftLine");_jcv.la2=this.l62("_jcv_rightLine");_jcv.l72=this.l62("_jcv_topLine");_jcv.l82=this.l62("_jcv_bottomLine");}
function _jcvp_false_function(){return false;}
_jcvp.l62=function(id){var d=document;if(d.body.insertAdjacentHTML){d.body.insertAdjacentHTML("BeforeEnd","<DIV ID='"+id+"' style='position:absolute;visibility:hidden;background-color:#000000;width:1px;height:1px;'><IMG WIDTH='1' HEIGHT='1'></DIV>");var lh1=ase_b(id);if(ase_7&&(ase_9()<5.5))lh1.onmousemove=_jcvp_false_function;return lh1;}
else if(d.createElement){var lh1=d.createElement("DIV");var s=lh1.style;s.position="absolute";s.visibility="hidden";s.backgroundColor="#000000";s.width="1px";s.height="1px";d.body.appendChild(lh1);return lh1;}
}
_jcvp.lk1=function(x,y,lv1,lw1){if(!_jcv.l92)this.lq1();if(!_jcv.l92)return;var lx1=_jcv.l92.style;var ly1=_jcv.la2.style;var lz1=_jcv.l72.style;var l02=_jcv.l82.style;lx1.left=lz1.left=l02.left=x+"px";lx1.top=ly1.top=lz1.top=y+"px";lz1.width=l02.width=lv1+"px";l02.top=(y+lw1-this.l8+1)+"px";lx1.height=ly1.height=lw1+"px";ly1.left=(x+lv1-this.l8+1)+"px";lx1.width=ly1.width=lz1.height=l02.height=this.l8+"px";lx1.backgroundColor=ly1.backgroundColor=lz1.backgroundColor=l02.backgroundColor=this.l9;}
_jcvp.ll1=function(b){if(b&&!_jcv.l72)this.lq1();if(ase_7&&_jcv.l72&&(ase_9()<5.5)){_jcv.l92.onmouseup=_jcv.la2.onmouseup=_jcv.l72.onmouseup=_jcv.l82.onmouseup=this.lt1().onmouseup;}
if(_jcv.l72)_jcv.l92.style.visibility=_jcv.la2.style.visibility=_jcv.l72.style.visibility=_jcv.l82.style.visibility=b?"visible":"hidden";}
_jcvp.la=_jcv.Default;_jcvp.lb=_jcv.Horizontal;_jcvp.lc=_jcv.Horizontal;_jcvp.ld=2;_jcvp.le=0.5;_jcvp.lf=0.01;_jcvp.lg=1;_jcvp.lh=0.01;_jcvp.li=1;_jcvp.getMouseUsage=function(){return this.la;}
_jcvp.setMouseUsage=function(l22){this.la=l22;if(ase_2&&(ase_a()<2))this.lf2();this.le2();}
_jcvp.lf2=function(){var a=this.lb2;if(a){switch(this.la){case _jcv.ZoomIn:a.href="javascript://ZoomIn";break;case _jcv.ZoomOut:a.href="javascript://ZoomOut";break;default:a.removeAttribute("href");}
}
}
_jcvp.getScrollDirection=function(){return this.lb;}
_jcvp.setScrollDirection=function(l42){this.lb=l42;this.le2();}
_jcvp.getZoomDirection=function(){return this.lc;}
_jcvp.setZoomDirection=function(l42){this.lc=l42;this.le2();}
_jcvp.getZoomInRatio=function(){return this.ld;}
_jcvp.setZoomInRatio=function(l52){if(l52>0)this.ld=l52;this.le2();}
_jcvp.getZoomOutRatio=function(){return this.le;}
_jcvp.setZoomOutRatio=function(l52){if(l52>0)this.le=l52;this.le2();}
_jcvp.getZoomInWidthLimit=function(){return this.lf;}
_jcvp.setZoomInWidthLimit=function(l52){this.lf=l52;this.le2();}
_jcvp.getZoomOutWidthLimit=function(){return this.lg;}
_jcvp.setZoomOutWidthLimit=function(l52){this.lg=l52;this.le2();}
_jcvp.getZoomInHeightLimit=function(){return this.lh;}
_jcvp.setZoomInHeightLimit=function(l52){this.lh=l52;this.le2();}
_jcvp.getZoomOutHeightLimit=function(){return this.li;}
_jcvp.setZoomOutHeightLimit=function(l52){this.li=l52;this.le2();}
_jcvp.lb1=function(){return((this.lc!=_jcv.Vertical)&&(this.l6>this.lf))||((this.lc!=_jcv.Horizontal)&&(this.l7>this.lh));}
_jcvp.lc1=function(){return((this.lc!=_jcv.Vertical)&&(this.l6<this.lg))||((this.lc!=_jcv.Horizontal)&&(this.l7<this.li));}
_jcvp.ls2=-1;_jcvp.lt2=-1;_jcvp.lj=5;_jcvp.getMinimumDrag=function(){return this.lj;}
_jcvp.setMinimumDrag=function(l62){this.lj=l62;this.le2();}
_jcvp.l41=function(e,d){var l72=Math.abs(ase_d(e)-this.ls2);var l82=Math.abs(ase_e(e)-this.lt2);switch(d){case _jcv.Horizontal:return l72>=this.lj;case _jcv.Vertical:return l82>=this.lj;default:return(l72>=this.lj)||(l82>=this.lj);}
}
_jcvp.onImgMouseDown=function(e){if(this.l01(ase_d(e),ase_e(e))&&(ase_f(e)==1)){if(e&&e.preventDefault&&(this.la!=_jcv.Default))e.preventDefault();this.ld2(true);this.ls(e);}
}
_jcvp.onImgMouseMove=function(e){if(this.l12&&window.event&&(ase_f(e)!=1)){this.ld2(false);this.l02=false;this.ll1(false);}
this.lz1=this.l12||this.l01(ase_d(e),ase_e(e));if(this.lz1){this.lu(e);if(this.l12){if((this.la!=_jcv.Default)&&this.lt1().useMap)this.lt1().useMap=null;this.lt(e);}
}
this.l11(this.lz(e));return this.la==_jcv.Default;}
_jcvp.onImgMouseUp=function(e){if(this.l12&&(ase_f(e)==1)){this.ld2(false);this.lv(e);}
}
_jcvp.ld2=function(b){var imgObj=this.lt1();if(b){if(((this.la==_jcv.ZoomIn)||(this.la==_jcv.ZoomOut))&&imgObj.useMap)imgObj.useMap=null;}
else {if(imgObj.useMap!=imgObj.lc2)imgObj.useMap=imgObj.lc2;}
if(!ase_7){if(b){if(!window._jcvOnMouseUpChain)window._jcvOnMouseUpChain=window.onmouseup;if(!window._jcvOnMouseMoveChain)window._jcvOnMouseMoveChain=window.onmousemove;window.onmouseup=imgObj.onmouseup;window.onmousemove=imgObj.onmousemove;}
else {window.onmouseup=window._jcvOnMouseUpChain;window.onmousemove=window._jcvOnMouseMoveChain;window._jcvOnMouseUpChain=null;window._jcvOnMouseMoveChain=null;}
}
this.l12=b;}
_jcvp.setZoomInCursor=function(l92){this.lk=l92;this.le2();}
_jcvp.getZoomInCursor=function(){return this.lk;}
_jcvp.setZoomOutCursor=function(l92){this.ll=l92;this.le2();}
_jcvp.getZoomOutCursor=function(){return this.ll;}
_jcvp.setNoZoomCursor=function(l92){this.lq=l92;this.le2();}
_jcvp.getNoZoomCursor=function(){return this.lq;}
_jcvp.setScrollCursor=function(l92){this.lm=l92;this.le2();}
_jcvp.getScrollCursor=function(){return this.lm;}
_jcvp.lw1=function(){if(ase_7&&(ase_9()<6.0))return "";switch(this.la){case _jcv.ZoomIn:if(this.lb1()){if(this.lk)return this.lk;else return ase_2?"-moz-zoom-in":"url('"+_jcv.l22('zoomin.cur')+"')";}
else {if(this.lq)return this.lq;else return ase_2?"default":"url('"+_jcv.l22('nozoom.cur')+"')";}
case _jcv.ZoomOut:if(this.lc1()){if(this.ll)return this.ll;else return ase_2?"-moz-zoom-out":"url('"+_jcv.l22('zoomout.cur')+"')";}
else {if(this.lq)return this.lq;else return ase_2?"default":"url('"+_jcv.l22('nozoom.cur')+"')";}
default:return "";}
}
_jcvp.lz=function(e){if(this.lm1)return "wait";if(this.l02){if(this.lm)return this.lm;switch(this.lb){case _jcv.Horizontal:return(ase_d(e)>=this.ls2)?"e-resize":"w-resize";case _jcv.Vertical:return(ase_e(e)>=this.lt2)?"s-resize":"n-resize";default:return "move";}
}
if(this.lz1)return this.lw1();else return "";}
_jcvp.l11=function(la2){if(la2!=this.lp1){this.lp1=la2;this.lt1().style.cursor=new String(la2);}
}
_jcvp.ls=function(e){this.ls2=ase_d(e);this.lt2=ase_e(e);}
_jcvp.lu=function(e){}
_jcvp.lt=function(e){var eX=ase_d(e);var eY=ase_e(e);if(this.la==_jcv.ZoomIn){var d=this.lc;var ld2=this.lb1()&&this.l41(e,d);if(ld2){var le2=Math.min(eX,this.ls2);var lf2=Math.min(eY,this.lt2);var l72=Math.abs(eX-this.ls2);var l82=Math.abs(eY-this.lt2);switch(d){case _jcv.Horizontal:this.lk1(le2,this.ln2(this.l1),l72,this.lk2(this.l3));break;case _jcv.Vertical:this.lk1(this.lm2(this.l0),lf2,this.ll2(this.l2),l82);break;default:this.lk1(le2,lf2,l72,l82);break;}
}
this.ll1(ld2);}
else if(this.la==_jcv.Scroll){var d=this.lb;if(this.l02||this.l41(e,d)){this.l02=true;var lg2=(d==_jcv.Vertical)?0:(eX-this.ls2);var lh2=(d==_jcv.Horizontal)?0:(eY-this.lt2);if((lg2<0)&&(this.l4+this.l6-this.l6*this.lp2(lg2)/this.l2>1))lg2=Math.min(0,(this.l4+this.l6-1)*this.l2/this.l6);if((lg2>0)&&(this.l6*this.lp2(lg2)/this.l2>this.l4))lg2=Math.max(0,this.l4*this.l2/this.l6);if((lh2<0)&&(this.l5+this.l7-this.l7*this.lo2(lh2)/this.l3>1))lh2=Math.min(0,(this.l5+this.l7-1)*this.l3/this.l7);if((lh2>0)&&(this.l7*this.lp2(lh2)/this.l3>this.l5))lh2=Math.max(0,this.l5*this.l3/this.l7);this.lk1(this.lm2(this.l0)+lg2,this.ln2(this.l1)+lh2,this.ll2(this.l2),this.lk2(this.l3));this.ll1(true);}
}
}
_jcvp.lv=function(e){this.ll1(false);switch(this.la){case _jcv.ZoomIn:if(this.lb1()){if(this.l41(e,this.lc))this.le1(e);else this.lg1(e,this.ld);}
break;case _jcv.ZoomOut:if(this.lc1())this.lg1(e,this.le);break;default:if(this.l02)this.lf1(e);break;}
this.l02=false;}
_jcvp.lg1=function(e,li2){var eX=ase_d(e);var eY=ase_e(e);var lj2=this.l6/li2;var lk2=this.l7/li2;this.l71(this.lc,(this.lq2(eX)-this.l0)*this.l6/this.l2-lj2/2,lj2,(this.lr2(eY)-this.l1)*this.l7/this.l3-lk2/2,lk2);}
_jcvp.lf1=function(e){var eX=ase_d(e);var eY=ase_e(e);this.l71(this.lb,this.l6*this.lp2(this.ls2-eX)/this.l2,this.l6,this.l7*this.lo2(this.lt2-eY)/this.l3,this.l7);}
_jcvp.le1=function(e){var eX=ase_d(e);var eY=ase_e(e);var lj2=this.l6*this.lp2(Math.abs(this.ls2-eX))/this.l2;var lk2=this.l7*this.lo2(Math.abs(this.lt2-eY))/this.l3;this.l71(this.lc,this.l6*(this.lq2(Math.min(this.ls2,eX))-this.l0)/this.l2,lj2,this.l7*(this.lr2(Math.min(this.lt2,eY))-this.l1)/this.l3,lk2);}
_jcvp.l71=function(d,ll2,lm2,ln2,lo2){var lp2=this.l4;var lq2=this.l5;var lj2=this.l6;var lk2=this.l7;if((((lm2<this.l6)&&(this.l6<this.lf))||(d==_jcv.Vertical))&&(((lo2<this.l7)&&(this.l7<this.lh))||(d==_jcv.Horizontal)))return;if(d!=_jcv.Vertical){if(lm2!=this.l6){lj2=Math.max(this.lf,Math.min(lm2,this.lg));ll2-=(lj2-lm2)/2;}
lp2=Math.max(0,Math.min(this.l4+ll2,1-lj2));}
if(d!=_jcv.Horizontal){if(lo2!=this.l7){lk2=Math.max(this.lh,Math.min(lo2,this.li));ln2-=(lk2-lo2)/2;}
lq2=Math.max(0,Math.min(this.l5+ln2,1-lk2));}
if((lp2!=this.l4)||(lq2!=this.l5)||(lj2!=this.l6)||(lk2!=this.l7)){this.lh2=this.l4;this.li2=this.l5;this.lj2=this.l6;this.lg2=this.l7;this.l4=lp2;this.l5=lq2;this.l6=lj2;this.l7=lk2;this.lp=1;this.le2();this.applyHandlers("viewportchanged");if(this.onViewPortChanged&&(this.lo1("viewportchanged").length==0))this.onViewPortChanged();this.lp=0;}
}
_jcvp.lo1=function(lr2){var id=(lr2+"events").toLowerCase();if(!this[id])this[id]=[];return this[id];}
_jcvp.attachHandler=function(lr2,f){var a=this.lo1(lr2);a[a.length]=f;return lr2+":"+(a.length-1);}
_jcvp.detachHandler=function(ls2){var ab=ls2.split(':');var a=this.lo1(ab[0]);a[parseInt(ab[1])]=null;}
_jcvp.applyHandlers=function(lr2){var lh1=false;var a=this.lo1(lr2);for(var i=0;i<a.length;++i){this.lu2=a[i];if(this.lu2!=null)lh1|=this.lu2();}
this.lu2=null;return lh1;}
_jcvp.partialUpdate=function(){if(this.lm1)return;_jcv.ld1(this.lt1());this.applyHandlers("preupdate");this.ln=1;this.le2();var lu2=this.updatingMsg;if(!lu2)lu2=_jcv.updatingMsg;if(lu2&&(lu2!="none"))this.msgBox(lu2);var lh=ase_k(ase_b(this.lr+"_callBackURL").value,"cdPartialUpdate="+this.lr+"&cdCacheDefeat="+(new Date().getTime())+"&"+this.lu1.name+"="+ase_l(escape(this.lu1.value),'\\+','%2B'));var lv2=this;this.lm1=true;ase_v(lh,function(t){lv2.l42(t)},function(lx2,ly2){lv2.lx(lx2,ly2);});}
_jcvp.l42=function(ls){var lz2=ase_n(ls,"<!--CD_SCRIPT "," CD_SCRIPT-->");if(lz2){var l03=ase_n(ls,"<!--CD_MAP "," CD_MAP-->");var imgObj=this.lt1();var imgBuffer=this.l61=(this.doubleBuffering)?new Image():imgObj;if(imgObj.useMap)imgObj.useMap=null;imgObj.loadImageMap=function(){window.setTimeout(function(){_jcv.putMap(imgObj,l03);},100);};imgBuffer.onload=function(){imgObj._jcv.onPartialLoad(true);}
imgBuffer.onerror=imgBuffer.onabort=function(lo1){imgObj._jcv.lx(999,"Error loading image '"+this.src+"'["+lo1+"]");}
var l23=window.onerror;window.onerror=function(lo1){imgObj._jcv.lx(801,"Error interpretating partial update result ["+lo1+"] <div style='margin:20px;background:#dddddd'><xmp>"+lz2+"</xmp></div>")};eval(lz2);window.onerror=l23;if(ase_2)this.le2();}
else this.lx(800,"Partial update returns invalid data <div style='margin:20px;background:#dddddd'><xmp>"+ls+"</xmp></div>");}
_jcvp.lw=function(l33){var imgObj=this.lt1();var imgBuffer=this.l61;if(imgBuffer)imgBuffer.onerror=imgBuffer.onabort=imgBuffer.onload='';imgObj.onUpdateCompleted='';this.lm1=false;if(l33){this.lh2=this.l4;this.lg2=this.l7;this.li2=this.l5;this.lj2=this.l6;if(imgObj!=imgBuffer){imgObj.src=imgBuffer.src;imgObj.style.width=imgBuffer.style.width;imgObj.style.height=imgBuffer.style.height;}
imgObj.loadImageMap();}
else {imgObj.useMap=imgObj.lc2;if(this.lj2||this.lg2){this.l4=this.lh2;this.l7=this.lg2;this.l5=this.li2;this.l6=this.lj2;this.le2();}
}
imgObj.loadImageMap='';}
_jcvp.onPartialLoad=function(l33){if(this.lt1().onUpdateCompleted)this.lt1().onUpdateCompleted();else this.msgBox();this.lw(l33);this.applyHandlers("postupdate");}
_jcvp.lx=function(lx2,ly2){this.lw(false);this.msgBox();this.errCode=lx2;this.errMsg=ly2;if(!this.applyHandlers("updateerror")){var l43=this.serverErrorMsg;if(!l43)l43=_jcv.serverErrorMsg;if(l43&&(l43!="none"))this.msgBox(ase_l(ase_l(l43,'%errCode',lx2),'%errMsg',ly2));}
this.errCode=null;this.errMsg=null;}
_jcvp.streamUpdate=function(l53){var l63=new Date().getTime();if(!l53)l53=60;var l73=this.l52;if(l73){if(l53*1000>=l63-l73.l51)return false;l73.src=null;l73.onerror=l73.onabort=l73.onload=null;}
if(!this.l32)this.l32=this.lt1().src;this.l52=l73=new Image();l73.l51=l63;var lv2=this;l73.onload=function(){var imgObj=lv2.lt1();if(imgObj.useMap)imgObj.useMap=null;var b=lv2.l52;if(imgObj!=b)imgObj.src=b.src;b.onabort();}
l73.onerror=l73.onabort=function(){var b=lv2.l52;if(b)b.onload=b.onabort=b.onerror=null;lv2.l52=null;}
l73.src=ase_k(this.l32,"cdDirectStream="+this.lr+"&cdCacheDefeat="+l63);return true;}
_jcvp.l91=function(a,v){return a+((typeof v!="number")?"**":"*")+v;}
_jcvp.l81=function(av){var lr=av.indexOf("*");if(lr==-1)return null;var a=av.substring(0,lr);var v=av.substring(lr+1,av.length);if(v.charAt(0)=="*")v=v.substring(1,v.length);else v=parseFloat(v);return{"attr":a,"value":v};}
_jcvp.la1=function(){var lh1="";for(var i=0;i<_jcv.lj1.length;++i){var a=_jcv.lj1[i];var v=null;if((a=="lo")&&this.lo){for(var lg in this.lo)v=((v==null)?"":v+"\x1f")+this.l91(lg,this.lo[lg]);}
else v=this[a];if((typeof v!="undefined")&&(null!=v))lh1+=(lh1?"\x1e":"")+this.l91(i,v);}
return lh1;}
_jcvp.decodeState=function(s){var l81=s.split("\x1e");for(var i=0;i<l81.length;++i){var av=this.l81(l81[i]);if(!av)continue;var a=_jcv.lj1[parseInt(av.attr)];if(a=="lo"){var l93=av.value.split("\x1f");for(var i2=0;i2<l93.length;++i2){var lb3=this.l81(l93[i2]);if(!lb3)continue;this.lo[lb3.attr]=lb3.value;}
}
else this[a]=av.value;}
this.lp=0;}
_jcvp.le2=function(){if(this.lu1)this.lu1.value=this.la1();}
_jcvp.ls1=function(){if(!ase_7){var imgObj=this.lt1();var m=_jcv.ln1(imgObj);if(m){m.onmousedown=imgObj.onmousedown;m.onmousemove=imgObj.onmousemove;if(((ase_2&&(ase_a()<2))||ase_4)&&document.createElement){var a=this.lb2=document.createElement("AREA");a.coords=""+this.l0+","+this.l1+","+(this.l0+this.l2)+","+(this.l1+this.l3);a.shape="rect";a.onclick="return false;";m.appendChild(a);m.ly1=a;if(!ase_4)this.lf2();}
}
}
}
_jcv.ln1=function(imgObj){var lc3=imgObj.lc2;if(!lc3)lc3=imgObj.useMap;if(!lc3)return null;var lr=lc3.indexOf('#');if(lr>=0)lc3=lc3.substring(lr+1);return ase_b(lc3);}
_jcv.loadMap=function(imgObj,lh){if(!imgObj.lc2)imgObj.lc2=imgObj.useMap;_jcv.ld1(imgObj);imgObj.lv1=ase_v(lh,function(t){_jcv.putMap(imgObj,ase_n(t,"<!--CD_MAP "," CD_MAP-->"));},function(lx2,ly2){_jcv.onLoadMapError(lx2,ly2);}
);}
_jcv.loadPendingMap=function(){if(!window._jcvPendingMap)return;for(var a in window._jcvPendingMap){var lf=ase_b(a);if(lf){var lh=window._jcvPendingMap[a];window._jcvPendingMap[a]=null;if(lh)_jcv.loadMap(lf,lh);}
}
}
_jcv.ld1=function(imgObj){if(imgObj.lv1){imgObj.lv1.abort();imgObj.lv1=null;}
}
_jcv.onLoadMapError=function(lx2,ly2){}
_jcv.putMap=function(imgObj,ld3){var m=_jcv.ln1(imgObj);if(!m&&ld3){var lc3='map_'+imgObj.id;imgObj.useMap=imgObj.lc2='#'+lc3;var d=document;if(d.body.insertAdjacentHTML){d.body.insertAdjacentHTML("BeforeEnd","<MAP ID='"+lc3+"'></MAP>");m=ase_b(lc3);}
else if(d.createElement){m=d.createElement("MAP");m.id=m.name=lc3;d.body.appendChild(m);}
if(imgObj._jcv)imgObj._jcv.ls1();}
if(m){m.innerHTML=ld3;if(m.ly1)m.appendChild(m.ly1);if(imgObj.useMap!=imgObj.lc2)imgObj.useMap=imgObj.lc2;}
imgObj.lv1=null;}
_jcv.canSupportPartialUpdate=function(){return((ase_7&&(ase_9()>=5.5))||window.XMLHttpRequest||ase_u());}
_jcv.getVersion=function(){return ase_0;}
JsChartViewer=_jcv;_jcv.loadPendingMap();