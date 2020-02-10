/*
  
  Magma doesn't compile user defined code, though it might have that
  option in the future.  So in strictly speaking everything done here 
  is meta-programming as it creates programs while running a program.  

  However, in the long run this should be seen as a crude attempt
  at adding generics to the magma language.  For example, it could
  be run ahead of time to create a pile of new types and intrinsics
  that could be loaded as part of a pacakge.  However, some may desire
  the flexibility of some meta-programming tools.  So the usage is
  up to him/her.

==================================================================
DEVELOPMENT NOTE: to maintain (co-)variance in generics will
require that all substitutions of a given type with generics
occur together, so their static substitutions can be wound
together.  This means to recompile the generic list with
ever new package.  This is compile time so fine, but requires
some supervision. 

Unfortunately, my attempt to store these and incremental
recompilation met with a magma issue that intrinsics can't
seem to access global state, such as the generic parse trees.
==================================================================
 */
declare type TemplateType;
declare attributes TemplateType : name, generics, templateCode;

// GLOBAL STATIC LIST OF ALREADY AVAILABLE GENERIC TYPES.
//__type_template_list := [TemplateType| ];
//update := procedure(t)
//    Append(~__type_template_list, t);
//end procedure;

// Used exclusively to for the set of meta types to 
// store exactly one template for each name.
intrinsic 'eq'(a::TemplateType, b::TemplateType) -> BoolElt
{Compare types with generics.}
    return (a`name eq b`name) and (a`generics eq b`generics);
end intrinsic;

intrinsic AttachTemplate( 
    filename::MonStgElt
) -> TemplateType
{Attaches code with generics, stores the build tree.}
    sourceCode := Read(filename);
    
    templateCode := "";
    tail := sourceCode;
    temTy := New(TemplateType);
    while #tail gt 0 do 
        // find "declare template Foo$A1,...,An$;""
        hasTemplate, resA, partsA := 
            Regexp( "(.*)declare[ \t]+template[ \t]+\{-}[:;]\+(.*)", tail );
        "", resA;
        "\r\n";
        "p", partsA;
        if hasTemplate then
        "resA", partsA;
            templateCode cat:= partsA[1];
            templateName := partsA[2];
            hasGenerics, resB, partsB := Regexp( 
                    "(.*).*\V$(.*)\V$", templateName );
            if hasGenerics then 
                temTy`name := partsB[1];
                temTy`generics := Split(partsB[2], "," );
                //update(t);
            else 
                "SYNTAX ERROR: needs\r\n\t declare template <Name>$<Generic1>,...,<Generic2>$;";
            end if;
            templateCode cat:= "declare type " cat templateName cat ";";
            
            tail := partsA[3];
        else
            tail := "";
        end if;
    end while;
    
    temTy`templateCode := templateCode;
    
    // whether new or old, give it the new type definition.
//    temp := &cat[filelines[i] cat "\r\n" : i in [3..#filelines]];
    // In the future should properly remove commented code from template.
//    t`parsetree := Split( temp, "$" );
    return temTy;
end intrinsic;


__eval_generic := function( node, generics, generic_map )
    if exists(i){i : i in [1..#generics] | node in generics } then
        return Sprint(generic_map[i]);
    else 
        return node;
    end if;
end function;

intrinsic CompileTemplate( 
    template::TemplateType, 
    generic_map::Any
) 
{}
    code := template`templateCode;
    evaluatedCode := "// MACHINE GENERATED CODE: EDITS WILL BE OVERWRITTEN\n\n";
    while #code gt 0 do
        foundGeneric, head, parts :=  Regexp( "(.*)$(.*)$(.*)", code );
        if foundGeneric then
    "head", head;
    "parts", parts;
            evaluatedCode cat:= head;
            evaluatedCode cat:= &cat[ __eval_generic(node,template`generics,generic_map)
                : node in template`parsetree ];
        end if;
        code := "";
    end while;
    evaltypename := template`name;
    specfilename := "magma-meta/" cat evaltypename cat ".spec";
    Write( specfilename,  "{\r\n\t" cat evaltypename cat ".m\r\n }\r\n" :
        Overwrite := true
     );
    AttachSpec( specfilename );
end intrinsic;
/*
// a static naming convention that (hopefully) does not polute the namespace.
__name := function (meta_name,generics)
    im := &cat[  g  : g in generics ];
    return meta_name cat im;// cat Sprint(StringToCode(meta_name cat im ));
end function;


intrinsic CompileGeneric(
    t::TemplateType,  
    generic_map::Any,
    ...
) 
{Compiles a new type by substituting the given list of types for the generics.}
    // Convert tuples into generic map.
 /*   if ISA(generic_map, Cat) then 
        generic_map := [generic_map];
    end if;
    require #generic_map eq #t`generics;
   */ 

    // We require the types provided be actuall types but we use 
    // them here only as strings.
 //   named_generic_map := [ Sprint(g) : g in generic_map];
    // Build a static unique identifier of the type
 //   evaltypename := __name(t`name,named_generic_map);
    // memoized type
//    if evaltypename in __meta_spec_list then
//        return; 
//    end if;

    // replace generics with values.
 //   evaluated_tree := &cat[ __eval_generic(node,t`generics,generic_map)
 //       : node in t`parsetree ];
 //   Write( "magma-meta/" cat evaltypename cat ".m", evaluated_tree :
 //       Overwrite := true );
//    Append(~__meta_spec_list, evaltypename );

    // Write an individual spec for it and attach
//    DetachSpec( __META_SPEC_FILE );
//    __write_meta_spec();   
//    AttachSpec( __META_SPEC_FILE );
/*
    specfilename := "magma-meta/" cat evaltypename cat ".spec";
    Write( specfilename,  "{\r\n\t" cat evaltypename cat ".m\r\n }\r\n" :
        Overwrite := true
     );
    AttachSpec( specfilename );
end intrinsic;
*/


/*
// Have a generic spec which loads 
// 
// List$A$.mt     
//
// it reads in this and converts each into a new generic type.
//
// To keep this roughly compile time, only advertized way to load 
// generic types is with a spec.
intrinsic AttachGenericSpec(
        filename::MonStgElt
) 
{Attaches the generic types in the file.}
    spec := Read(filename);
    lines := Split(spec, "\n");
    for filename in lines do
        try
            gdef := Read(filename);
            filelines := Split(gdef, "\n");
            // For ease sssumes files starts with
            // <name>
            // A,B,C,...
            name := fileline[s1]; 
            generics := Split(filelines[2],",");
            // if there is such a type, match the generic, and blow away the old.
            test := exists(t){g : g in __type_generics_list | g`name eq name };
            if not test then
                t := New(TemplateType);
                t`name := name;
                t`generics := generics;
                update(t);
            end if;
            // whether new or old, give it the new type definition.
            temp := &cat[filelines[i] : i in [3..#filelines]];
            // In the future should properly remove commented code from template.
            t`parsetree := Split( temp, "$" );
        catch
            Print( "Invalid file or format.\n" );
        end try;
    end for;
end intrinsic;

intrinsic AttachSpecWithGenerics(
        filename::MonStgElt
) 
{Attaches the generic types in the file.}
    spec := Read(filename);
    lines := Split(spec, "\n");
    for filename in lines do
        try
            thedef := Read(filename);
            isit, substr, middle := Regexp( thedef, "from-generic(.*);" );
            terms := Split(middle, "$");
            name := terms[1];
            generics := terms[2..#terms];
            
        catch
            Print( "Invalid file or format.\n" );
        end try;
    end for;
end intrinsic;
*/