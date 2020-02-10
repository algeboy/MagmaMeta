declare type Option$RngIntElt$;declare type None$RngIntElt$ : 
Option$RngIntElt$;declare type Some$RngIntElt$ : Option$RngIntElt$;declare 
attributes Some$RngIntElt$ : __val;intrinsic Unapply(s::Some$RngIntElt$) -> 
$RngIntElt${Unapply to extract the value of some.}    return s`__val;end 
intrinsic;instrinsic Unit(a:$RngIntElt$) -> Option$RngIntElt$ {}    return 
Some(a);end instrinsic;intrinsic Some(a:$RngIntElt$) -> Some$RngIntElt$ {}    op
:= New( Some$RngIntElt$ );    op`__val := a;    return op;end 
intrinsic;intrinsic map(a:Option$RngIntElt$,f:$RngIntElt$=>B) -> OptionB{}    if
ISA(a,None$RngIntElt$) then         return New( NoneB );    else        sb := 
New(OptionB);        sb`__val := Unapply(a) @ f;        return sb;    end if;end
intrinsic;intrinsic join(a:OptionOption$RngIntElt$) -> Option$RngIntElt${}    if
ISA(a,NoneOption$RngIntElt$) then         return New( None$RngIntElt$ );    else
return Unapply(a);    end if;end intrinsic;
