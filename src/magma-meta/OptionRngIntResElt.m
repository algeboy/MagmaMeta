declare type OptionAny;

declare type NoneType : OptionAny;

__the_none := New(NoneType);

intrinsic Print(a::NoneType)

{}

    print("None");

end intrinsic;

intrinsic None() -> NoneType

{}

    return __the_none;

end intrinsic;

intrinsic 'eq'(x::NoneType, y::NoneType) -> BoolElt

{}

    return true;

end intrinsic;

declare type OptionRngIntResElt : OptionAny;

declare type SomeRngIntResElt : OptionRngIntResElt;

declare attributes SomeRngIntResElt : __val;

intrinsic Unapply(s::SomeRngIntResElt) -> RngIntResElt

{Unapply to extract the value of some.}

    return s`__val;

end intrinsic;

intrinsic Print(a::SomeRngIntResElt) 

{}

    print(Unapply(a));

end intrinsic;

intrinsic Some(a::RngIntResElt) -> SomeRngIntResElt 

{}

    op := New( SomeRngIntResElt );

    op`__val := a;

    return op;

end intrinsic;

intrinsic Unit(a::RngIntResElt) -> OptionRngIntResElt 

{}

    return Some(a);

end intrinsic;

/*

intrinsic map(a::OptionRngIntResElt,f::RngIntResElt=>B) -> OptionB

{}

    if ISA(a,NoneRngIntResElt) then 

        return New( NoneB );

    else

        sb := New(OptionB);

        sb`__val := Unapply(a) @ f;

        return sb;

    end if;

end intrinsic;

intrinsic join(a:OptionOptionRngIntResElt) -> OptionRngIntResElt

{}

    if ISA(a,NoneOptionRngIntResElt) then 

        return New( NoneRngIntResElt );

    else

        return Unapply(a);

    end if;

end intrinsic;

*/


