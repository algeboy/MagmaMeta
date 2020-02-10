/*

 Tools to form the join and meet of magma types.

 Joins/meets only work for packages, this is because 
 magma doesn't really check types unless as in an input
 in an intrinsic.   Since intrinsics can only appear 
 for packages there is no point in supporting it more
 broadly, and I don't really see how.



 */

declare type JoinTypeCat;
declare attributes JoinTypeCat : left, right;

intrinsic NewJoinTypes(
    left::Cat,
    right::Cat
) -> JoinTypeCat
{t:Type := left | right}
    t := New(JoinTypeCat);
    t`left := left;
    t`right := right;
    return t;
end intrinsic;

intrinsic CompileJoinType(
    join::JoinTypeCat,

)
{}
    // the joins/meets are written as generics.
    // now replace by evaluation at each type.
    
    filename := "magma-meta/temp-join" cat Random() cat ".mt";
    asgeneric := NewGenericType( filename );
    for t in joinedTypes do
        CompileGeneric( asgeneric, t );
    end for;
    

end intrinsic;