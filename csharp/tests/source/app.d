module app;

import test;
import autowrap.csharp;

immutable Modules modules = Modules(Module("test"));

mixin(
    wrapCSharp(
        modules,
        OutputFileName("Wrapper.cs"),
        LibraryName("csharp-tests"),
        RootNamespace("Autowrap.CSharp.Tests")
    )
);

<<<<<<< HEAD
//pragma(msg, wrapDLang!(Module("test"))); //Uncomment this to see the generated interface code.
=======
//pragma(msg, wrapDLang!(Module("test"))); //Uncomment this to see generated D interface code.
>>>>>>> datetime
