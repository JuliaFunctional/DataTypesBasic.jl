var documenterSearchIndex = {"docs":
[{"location":"library/","page":"Library","title":"Library","text":"CurrentModule = DataTypesBasic","category":"page"},{"location":"library/#Public-API","page":"Library","title":"Public API","text":"","category":"section"},{"location":"library/","page":"Library","title":"Library","text":"","category":"page"},{"location":"library/#Identity","page":"Library","title":"Identity","text":"","category":"section"},{"location":"library/","page":"Library","title":"Library","text":"Identity\nisidentity","category":"page"},{"location":"library/#DataTypesBasic.Identity","page":"Library","title":"DataTypesBasic.Identity","text":"Identity(:anything)\n\nIdentity is a simple wrapper, which works as a single-element container.\n\nIt can be used as the trivial Monad, and as such can be helpful in monadic abstractions. For those who don't know about Monads, just think of it like container-abstractions.\n\n\n\n\n\n","category":"type"},{"location":"library/#DataTypesBasic.isidentity","page":"Library","title":"DataTypesBasic.isidentity","text":"isidentity(Identity(3)) -> true\nisidentity(\"anythingelse\") -> false\n\nreturns true only if given an instance of  Identity\n\n\n\n\n\n","category":"function"},{"location":"library/#Const","page":"Library","title":"Const","text":"","category":"section"},{"location":"library/","page":"Library","title":"Library","text":"Const\nBase.isconst(::Const)","category":"page"},{"location":"library/#DataTypesBasic.Const","page":"Library","title":"DataTypesBasic.Const","text":"Const(\"anything\")\n\nDataType which behaves constant among map, foreach and the like. Just like an empty container, however with additional information about which kind of empty.\n\n\n\n\n\n","category":"type"},{"location":"library/#Base.isconst-Tuple{Const}","page":"Library","title":"Base.isconst","text":"isconst(Const(3)) -> true\nisconst(\"anythingelse\") -> false\n\nreturns true only if given an instance of  DataTypesBasic.Const\n\n\n\n\n\n","category":"method"},{"location":"library/#Option","page":"Library","title":"Option","text":"","category":"section"},{"location":"library/","page":"Library","title":"Library","text":"Option\nisoption\nissome\nisnone\niftrue\niffalse","category":"page"},{"location":"library/#DataTypesBasic.Option","page":"Library","title":"DataTypesBasic.Option","text":"Option{T} = Union{Const{Nothing}, Identity{T}}\nOption(nothing) == Const(nothing)\nOption(\"anything but nothing\") == Identity(\"anything but nothing\")\nOption() == Const(nothing)\n\nLike Union{T, Nothing}, however with container semantics. While Union{T, Nothing} can be thought of like a value which either exists or not, Option{T} = Union{Identity{T}, Const{Nothing}} is a container which is either empty or has exactly one element.\n\nWe reuse Identity as representing the single-element-container and Const(nothing) as the empty container.\n\n\n\n\n\n","category":"constant"},{"location":"library/#DataTypesBasic.isoption","page":"Library","title":"DataTypesBasic.isoption","text":"isoption(::Const{Nothing}) = true\nisoption(::Identity) = true\nisoption(other) = false\n\ncheck whether something is an Option\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.issome","page":"Library","title":"DataTypesBasic.issome","text":"issome(::Identity) = true\nissome(::Const{Nothing}) = false\n\nSimilar to isright, but only defined for Const{Nothing}. Will throw MethodError when applied on other Const.\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.isnone","page":"Library","title":"DataTypesBasic.isnone","text":"isnone(::Identity) = false\nisnone(::Const{Nothing}) = true\n\nSimilar to isleft, but only defined for Const{Nothing}. Will throw MethodError when applied on other Const.\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.iftrue","page":"Library","title":"DataTypesBasic.iftrue","text":"iftrue(bool_condition, value)\niftrue(func, bool_condition)\niftrue(bool_condition) do\n  # only executed if bool_condition is true\nend\n\nHelper to create an Option based on some condition. If bool_condition is true, the function func is called with no arguments, and its result wrapped into Identity. If bool_condition is false, Option() is returned.\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.iffalse","page":"Library","title":"DataTypesBasic.iffalse","text":"iffalse(bool_condition, value)\niffalse(func, bool_condition)\niffalse(bool_condition) do\n  # only executed if bool_condition is true\nend\n\nHelper to create an Option based on some condition. If bool_condition is false, the function func is called with no arguments, and its result wrapped into Identity. If bool_condition is true, Option() is returned.\n\nPrecisely the opposite of iftrue.\n\n\n\n\n\n","category":"function"},{"location":"library/#Either","page":"Library","title":"Either","text":"","category":"section"},{"location":"library/","page":"Library","title":"Library","text":"Either\niseither\nisleft\nisright\neither\n@either\ngetleft\ngetright\ngetleftOption\ngetrightOption\ngetOption","category":"page"},{"location":"library/#DataTypesBasic.Either","page":"Library","title":"DataTypesBasic.Either","text":"Either{L, R} = Union{Const{L}, Identity{R}}\nEither{Int, Bool}(true) == Identity(true)\nEither{Int, Bool}(1) == Const(1)\nEither{String}(\"left\") == Const(\"left\")\nEither{String}(:anythingelse) == Identity(:anythingelse)\n\nA very common type to represent Result or Failure. We reuse Identity as representing \"Success\" and Const for \"Failure\".\n\n\n\n\n\n","category":"constant"},{"location":"library/#DataTypesBasic.iseither","page":"Library","title":"DataTypesBasic.iseither","text":"iseither(::Const) = true\niseither(::Identity) = true\niseither(other) = false\n\ncheck whether something is an Either\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.isleft","page":"Library","title":"DataTypesBasic.isleft","text":"isleft(::Const) = true\nisleft(::Identity) = false\n\nIdentical to isconst, but might be easier to read when working with Either.\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.isright","page":"Library","title":"DataTypesBasic.isright","text":"isright(::Const) = false\nisright(::Identity) = true\n\nIdentical to isidentity, but might be easier to read when working with Either.\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.either","page":"Library","title":"DataTypesBasic.either","text":"either(:left, bool_condition, \"right\")\n\nIf bool_condition is true, it returns the right value, wrapped into Identity. Else returns left side, wrapped into Const.\n\nExample\n\neither(:left, 1 < 2, \"right\") == Identity(\"right\")\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.@either","page":"Library","title":"DataTypesBasic.@either","text":"@either true ? \"right\" : Symbol(\"left\")\n@either if false\n  \"right\"\nelse\n  :left\nend\n\nSimple macro to reuse ? operator and simple if-else for constructing Either.\n\n\n\n\n\n","category":"macro"},{"location":"library/#DataTypesBasic.getleft","page":"Library","title":"DataTypesBasic.getleft","text":"getleft(Const(:something)) == :something\ngetleft(Identity(23))  # throws MethodError\n\nExtract a value from a \"left\" Const value. Will result in loud error when used on anything else.\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.getright","page":"Library","title":"DataTypesBasic.getright","text":"getright(Identity(23)) == 23\ngetright(Const(:something))  # throws MethodError\n\nExtract a value from a \"right\" Identity value. Will result in loud error when used on anything else. Identical to Base.get but explicit about the site (and not defined for other things)\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.getleftOption","page":"Library","title":"DataTypesBasic.getleftOption","text":"getleftOption(Identity(23)) == Option()\ngetleftOption(Const(:something)) == Option(:something)\n\nConvert to option, assuming you want to have the left value be preserved.\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.getrightOption","page":"Library","title":"DataTypesBasic.getrightOption","text":"getrightOption(Identity(23)) == Option(23)\ngetrightOption(Const(:something)) == Option()\n\nConvert to option, assuming you want to have the right value be preserved. Identical to getOption, just explicit about the site.\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.getOption","page":"Library","title":"DataTypesBasic.getOption","text":"getOption(Identity(23)) == Option(23)\ngetOption(Const(:something)) == Option()\n\nConvert to option, assuming you want to have the right value be preserved, and the left value represented as Option().\n\n\n\n\n\n","category":"function"},{"location":"library/#Try","page":"Library","title":"Try","text":"","category":"section"},{"location":"library/","page":"Library","title":"Library","text":"Try\n@Try\n@TryCatch\nistry\nissuccess\nisfailure\ngetOption","category":"page"},{"location":"library/#DataTypesBasic.Try","page":"Library","title":"DataTypesBasic.Try","text":"Try{T} = Union{Const{<:Exception}, Identity{T}}\n@Try(error(\"something happend\")) isa Const(<:Thrown{ErrorException})\n@Try(:successfull) == Identity(:successfull)\n\nA specific case of Either, where the Failure is always an Exception. This can be used as an alternative to using try-catch syntax and allows for very flexible error handling, as the error is now captured in a proper defined type. Often it is really handy to treat errors like other values (without the need of extra try-catch syntax which only applies to exceptions).\n\nWe reuse Identity for representing the single-element-container and Const(<:Exception) as the Exception thrown.\n\n\n\n\n\n","category":"constant"},{"location":"library/#DataTypesBasic.@Try","page":"Library","title":"DataTypesBasic.@Try","text":"@Try begin\n  your_code\nend\n\nMacro which directly captures an Excpetion into a proper Tryrepresentation.\n\nIt translates to\n\ntry\n  r = your_code\n  Identity(r)\ncatch exc\n  Const(Thrown(exc, Base.catch_stack()))\nend\n\n\n\n\n\n","category":"macro"},{"location":"library/#DataTypesBasic.@TryCatch","page":"Library","title":"DataTypesBasic.@TryCatch","text":"@TryCatch YourException begin\n  your_code\nend\n\nA version of @Try which catches only specific errors. Every other orrer will be rethrown.\n\nIt translates to\n\ntry\n  r = your_code\n  Identity(r)\ncatch exc\n  if exc isa YourException\n    Const(Thrown(exc, Base.catch_stack()))\n  else\n    rethrow()\n  end\nend\n\n\n\n\n\n","category":"macro"},{"location":"library/#DataTypesBasic.istry","page":"Library","title":"DataTypesBasic.istry","text":"isoption(::Const{Nothing}) = true\nisoption(::Identity) = true\nisoption(other) = false\n\ncheck whether something is a Try\n\n\n\n\n\n","category":"function"},{"location":"library/#DataTypesBasic.issuccess","page":"Library","title":"DataTypesBasic.issuccess","text":"issuccess(::Identity) = true\nissuccess(::Const{<:Exception}) = false\n\nSimilar to isright, but only defined for Const{<:Exception}. Will throw MethodError when applied on other Const.\n\n\n\n\n\n","category":"function"},{"location":"library/#ContextManager","page":"Library","title":"ContextManager","text":"","category":"section"},{"location":"library/","page":"Library","title":"Library","text":"ContextManager\n@ContextManager\nBase.run(::ContextManager)","category":"page"},{"location":"library/#DataTypesBasic.ContextManager","page":"Library","title":"DataTypesBasic.ContextManager","text":"ContextManager(func)\n\nAs ContextManager we denote a computation which has a pre-computation and possibly a cleaning up step.\n\nThe single argument is supposed to be a function which expects one argument, the continuation function. Think of it like the following:\n\nfunction contextmanagerready(cont)\n  # ... do something before\n  value = ... # create some value to work on later\n  result = cont(value)  # pass the value to the continuation function (think like `yield`)\n  # ... do something before exiting, e.g. cleaning up\n  result # IMPORTANT: always return the result of the `cont` function\nend\n\nNow you can wrap it into ContextManager(contextmanagerready) and you can use all the context manager functionalities right away.\n\nThere is a simple @ContextManager for writing less parentheses\n\nmycontextmanager(value) = @ContextManager function(cont)\n  println(\"got value = $value\")\n  result = cont(value)\n  println(\"finished value = $value\")\n  result\nend\n\n\n\nYou can run it in two ways, either by just passing Base.identity as the continuation function\n\njulia> mycontextmanager(4)(x -> x)\ngot value = 4\nfinished value = 4\n\nor for convenience we also overload Base.run\n\n# without any extra arguments runs the contextmanager with Base.identity\nrun(mycontextmanager(4))\n# also works with a given continuation, which makes for a nice do-syntax\nrun(x -> x, mycontextmanager(4))\nrun(mycontextmanager(4)) do x\n  x\nend\n\n\n\n\n\n","category":"type"},{"location":"library/#DataTypesBasic.@ContextManager","page":"Library","title":"DataTypesBasic.@ContextManager","text":"@ContextManager function(cont); ...; end\n\nThere is a simple @ContextManager for writing less parentheses\n\nmycontextmanager(value) = @ContextManager function(cont)\n  println(\"got value = $value\")\n  result = cont(value)\n  println(\"finished value = $value\")\n  result\nend\n\n\n\n\n\n","category":"macro"},{"location":"manual/#Manual","page":"Manual","title":"Manual","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"This package defines julia implementations for the common types Option (aka Maybe), Either and Try, as well as one extra type ContextManager which mimics Python's with-ContextManager.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Unlike typical implementations of Option, and Either which define them as new separate type-hierarchies, in DataTypesBasic both actually share a common parts: Identity and Const.","category":"page"},{"location":"manual/#Identity","page":"Manual","title":"Identity","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Identity is the most basic container you can imagine. It just contains one value and always one value. It is similar to Base.Some, however with one notable difference. While Some([]) != Some([]) (because it is treated more like Ref), for Identity we have Identity([]) == Identity([]), as Identity works like a Container.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"julia> a = Identity(3)\nIdentity(3)\njulia> map(x -> 2x, a)\nIdentity(6)\njulia> foreach(println, a)\n3\njulia> for i in Identity(\"hello\")\n         print(\"$i world\")\n       end\nhello world","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Think of Identity as lifting a value into the world of containers. DataTypesBasic knows a lot about how to convert an Identity container to a Vector or else. This will come in handy soon. For now it is important to understand that wrapping some value 42 into Identity(42) makes it interactable on a container-level.","category":"page"},{"location":"manual/#Const","page":"Manual","title":"Const","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Const looks like Identity, but behaves like an empty container. Its name suggests that whatever is in it will stay constant. Alternatively, it can also be interpreted as aborting a program. Use Const(nothing) to represent an empty Container. Const(...) is in this sense an empty container with additional information.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"struct Identity{T}\n  value::T\nend\nstruct Const{T}\n  value::T\nend","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"julia> a = Const(3)\nConst(3)\njulia> map(x -> 2x, a)\nConst(3)\njulia> foreach(println, a)\n\njulia> for i in Identity(\"hello\")\n         print(\"$i world\")\n       end\n","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"","category":"page"},{"location":"manual/#Option","page":"Manual","title":"Option","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Option is a container which has either 1 value or 0. Having Identity and Const{Nothing} already at hand, it is defined as","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Option{T} = Union{Identity{T}, Const{Nothing}}","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Use it like","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"using DataTypesBasic\n\nfo(a::Identity{String}) = a.value * \"!\"\nfo(a::Const{Nothing}) = \"fallback behaviour\"\n\nfo(Option(\"hi\"))  # \"hi!\"\nfo(Option(nothing))  # \"fallback behaviour\"\nfo(Option())  # \"fallback behaviour\"","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"The real power of Option comes from generic functionalities which you can define on it. DataTypesBasic already defines the following: Base.iterate, Base.foreach, Base.map, Base.get, Base.Iterators.flatten, DataTypesBasic.iftrue, DataTypesBasic.iffalse, Base.isnothing, DataTypesBasic.issomething. Please consult the respective function definition for details.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Here an example for such a higher level perspective","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"using DataTypesBasic\n\nflatten(a::Identity) = a.value\nflatten(a::Const) = a\n\n# map a function over 2 Options, getting an option back\nfunction map2(f, a::Option{S}, b::Option{T}) where {S, T}\n  nested_option = map(a) do a′\n    map(b) do b′\n      f(a′, b′)\n    end\n  end\n  flatten(nested_option)\nend\n\nmap2(Option(\"hi\"), Option(\"there\")) do a, b\n  \"$a $b\"\nend  # Identity(\"hi there\")\n\nmap2(Option(1), Option()) do a, b\n  a + b\nend  # Const(nothing)","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"The package TypeClasses.jl (soon to come) implements a couple of such higher level concepts of immense use (like Functors, Applicatives and Monads).","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"For further details, don't hesitate to consult the source code src/Option.jl or take a look at the tests test/Option.jl.","category":"page"},{"location":"manual/#Either","page":"Manual","title":"Either","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Either is exactly like Option a container which has either 1 value or 0. In addition to Option, the Either data type captures extra information about the empty case.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"As such it is defined as a union of the two types Identity and Const.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Either{Left, Right} = Union{Const{Left}, Identity{Right}}","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"It is typical to describe the Const part as \"Left\" in the double meaning of being the left type-parameter as well as a hint about its semantics of describing the empty case, like \"what is finally left\". On the other hand \"Right\" also has its double meaning of being the right type-parameter, and also the \"the right value\" in the sense of correct (no abort).","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Use it like","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"using DataTypesBasic\n\nfe(a::Identity{Int}) = a.value * a.value\nfe(a::Const{String}) = \"fallback behaviour '$(a.value)'\"\n\nfe(Either{String}(7))  # 49\nfe(Either{String}(\"some error occured\"))  # \"fallback behaviour 'some error occured'\"\n\nmyeither = either(\"error\", 2 > 3, 42)\nfe(myeither)  # \"fallback behaviour 'error'\"","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"You also have support for Iterators.flatten in order to work \"withing\" Either, and combine everything correctly.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"check_threshold(a) = a < 15 ? Const((a, \"threshold not reached\")) : Identity(\"checked threshold successfully\")\n\nmap(check_threshold, Identity(30)) |> Iterators.flatten  # Identity(\"checked threshold successfully\")\nmap(check_threshold, Identity(12)) |> Iterators.flatten  # Const((12, \"threshold not reached\"))\n# when working within another Const, think of it as if the first abort always \"wins\"\nmap(check_threshold, Const(\"something different already happend\")) |> Iterators.flatten  # Const(\"something different already happend\")","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Similar like for Option, there are many higher-level concepts (like Functors, Applicatives and Monads) which power unfold also over Either. Checkout the package TypeClasses.jl (soon to come) for a collection of standard helpers and interfaces.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"For further details, don't hesitate to consult the source code src/Either.jl or take a look at the tests test/Either.jl.","category":"page"},{"location":"manual/#Try","page":"Manual","title":"Try","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Try is another special case of Either, where Const can only bear Exceptions.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Try{T} = Union{Const{<:Exception}, Identity{T}}","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"This is very handy. It gives you the possibility to work with errors just as you would do with other values, no need for dealing with try-catch.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Use it like","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"using DataTypesBasic\n\nft(a::Identity) = a.value * a.value\nft(a::Const{<:Exception}) = \"got an error '$(a.value)'\"\n\nft(@Try 1/0)  # Inf\nft(@TryCatch ErrorException error(\"some error\"))  # \"got an error 'Thrown(ErrorException(\\\"some error\\\"))'\"\n\nft(@TryCatch ArgumentError error(\"another error\"))  # raises the error as normal","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"There are many higher-level concepts (like Functors, Applicatives and Monads) which power also applies to Try. Checkout the package TypeClasses.jl (soon to come) for a collection of standard helpers and interfaces.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"For further details, don't hesitate to consult the source code src/Try.jl or take a look at the tests test/Try.jl.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"","category":"page"},{"location":"manual/#ContextManager","page":"Manual","title":"ContextManager","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Finally there is the context-manager. It is quite separate from the others, however still one of my major containers which I used a lot in my passed in other programming languages. For instance in Python context-managers have the extra with syntax, which allows you to wrap code blocks very simply with some Initialization & Cleanup, handled by the context-manager.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"The way we represent a contextmanager is actually very compact. \"\"\" function which expects one argument, which itself is a function. Think of it like the following:","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"struct ContextManager{Func}\n  f::Func\nend","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"It just takes a function. However the function needs to follow some rules","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"function contextmanagerready_func(cont)  # take only a single argument, the continuation function `cont`\n  # ... do something before\n  value = ... # create some value to work on later\n  result = cont(value)  # pass the value to the continuation function (think like `yield`, but call exactly once)\n  # ... do something before exiting, e.g. cleaning up\n  result # IMPORTANT: always return the result of the `cont` function\nend","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Now you can wrap it into ContextManager(contextmanagerready) and you can use all the context manager functionalities right away.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Let's create some ContextManagers","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"using DataTypesBasic\ncontext_print(value) = ContextManager(function(cont)\n  println(\"initializing value=$value\")\n  result = cont(value)\n  println(\"finalizing value=$value, got result=$result\")\n  result\nend)\n\n# for convenience we also provide a `@ContextManager` macro which is the same as plain `ContextManager`,\n# however you can leave out the extra parantheses.\ncontext_ref(value) = @ContextManager function(cont)\n  refvalue = Ref{Any}(value)\n  println(\"setup Ref $refvalue\")\n  result = cont(refvalue)\n  refvalue[] = nothing\n  println(\"destroyed Ref $refvalue\")\n  result\nend\n\n# we can try out a contextmanager, by providing `identity` as the continuation `cont`\ncontext_print(\"value\")(identity)  # 4\n# initializing value=4\n# finalizing value=4, got result=4\n\n# or alternatively we can use Base.run\nrun(context_ref(4))  # Base.RefValue{Any}(nothing)\n# setup Ref Base.RefValue{Any}(4)\n# destroyed Ref Base.RefValue{Any}(nothing)","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"In a sense, these ContextManagers are a simple value with some sideeffects before and after. In functional programming it is key to cleanly captualize such side effects. That is also another reason why Option, Either, and Try are so common.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Using Monadic.jl we can actually work on ContextManagers as they would be values.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"using Monadic\nflatmap(f, x) = Iterators.flatten(map(f, x))\ncombined_context = @monadic map flatmap begin\n  a = context_print(4)\n  b = context_ref(a + 100)\n  @pure a * b[]\nend\n\nrun(combined_context)  # 416\n# initializing value=4\n# setup Ref Base.RefValue{Any}(104)\n# destroyed Ref Base.RefValue{Any}(nothing)\n# finalizing value=4, got result=416","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"As you see, the contextmanager properly nest into one-another. And everything is well captured in the background by the @monadic syntax. This working pattern is very common and can also be used for Option, Either and Try. The syntax is called monadic, as map and flatmap define what in functional programming is called a Monad (think   of it as a container which knows how to flatten out itself).","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"The package TypeClasses.jl captures this idea in more depth. There you can also find a syntax @syntax_flatmap  which refers to exactly the above use of @monadic.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"For further details, don't hesitate to consult the source code src/ContextManager.jl or take a look at the tests test/ContextManager.jl.","category":"page"},{"location":"#DataTypesBasic.jl","page":"Home","title":"DataTypesBasic.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package defines julia implementations for the common types Option (aka Maybe), Either and Try, as well as one extra type ContextManager which mimics Python's with-ContextManager.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"using Pkg\npkg\"registry add https://github.com/JuliaRegistries/General\"  # central julia registry\npkg\"registry add https://github.com/schlichtanders/SchlichtandersJuliaRegistry.jl\"  # custom registry\npkg\"add DataTypesBasic\"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Use it like","category":"page"},{"location":"","page":"Home","title":"Home","text":"using DataTypesBasic","category":"page"},{"location":"#Manual-Outline","page":"Home","title":"Manual Outline","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"manual.md\"]","category":"page"},{"location":"#main-index","page":"Home","title":"Library Index","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"library.md\"]","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"library.md\"]","category":"page"}]
}