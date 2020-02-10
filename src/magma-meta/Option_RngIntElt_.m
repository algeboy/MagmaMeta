declare type Option_RngIntElt_;declare type None_RngIntElt_ : 
Option_RngIntElt_;declare type Some_RngIntElt_ : Option_RngIntElt_;declare 
attributes Some_RngIntElt_ : __val;intrinsic Unapply(s::Some_RngIntElt_) -> 
_RngIntElt_{Unapply to extract the value of some.}    return s`__val;end 
intrinsic;instrinsic Unit(a:_RngIntElt_) -> Option_RngIntElt_ {}    return 
Some(a);end instrinsic;intrinsic Some(a:_RngIntElt_) -> Some_RngIntElt_ {}    op
:= New( Some_RngIntElt_ );    op`__val := a;    return op;end 
intrinsic;intrinsic map(a:Option_RngIntElt_,f:_RngIntElt_=>B) -> OptionB{}    if
ISA(a,None_RngIntElt_) then         return New( NoneB );    else        sb := 
New(OptionB);        sb`__val := Unapply(a) @ f;        return sb;    end if;end
intrinsic;intrinsic join(a:OptionOption_RngIntElt_) -> Option_RngIntElt_{}    if
ISA(a,NoneOption_RngIntElt_) then         return New( None_RngIntElt_ );    else
return Unapply(a);    end if;end intrinsic;
