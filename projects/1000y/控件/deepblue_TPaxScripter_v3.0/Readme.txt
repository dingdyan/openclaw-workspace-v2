TPaxScripter for Delphi 5, 6, 7, 2005, BCB 5, BCB 6, Kylix 3.
------------------------------------------------------------------------------
Version: 3.0.
Build: 15 October, 2007.
Status: Registered.
Copyright (c) 2003-2006 Alexander Baranovsky
Author: Alexander Baranovsky
E-Mail: ab@cable.netlux.org
Website : http://www.paxscript.com/
            
paxScript is an interpreter of 4 object-oriented scripting languages: paxBasic, paxC, paxJavaScript 
and paxPascal.

The key features of the paxScript are:

. All pax-languages support such concepts of the modern programming as namespaces, nested classes, 
  inheritance, static(shared) members, indexed properties, default parameters, delegates, exception
  handling, regular expressions. If you know VB.NET, C# or Object Pascal, you are already familiar
  with paxScript.
. Cross-language integration. For example, you can use modules written in paxBasic and paxC in your
  paxPascal scripts and vice versa. 
. Separate compilation of the modules. 
. Direct calling dll-defined routines. All calling conventions register, pascal, cdecl, stdcall, 
  safecall are supported. 
. Embedding scripts into html pages.

All paxScript languages support LISPPA technology which considerably extends the applicability of 
imperative programming languages in the symbolic computations and AI applications. 

TPaxScripter component allows to embed paxScript interpreter into your Delphi or Borland C++ Builder 
application, so you can extend and customize the application without having to recompile it.

Using TPaxScripter you can

. Import Delphi classes routines, constants, and variables. 
. Import Delphi units automatically with paxScript Importer.
. Convert dfm-files into the paxPascal scripts.
. Call script-defined functions. 
. Save/Load compiled scripts to/from a stream. 
. Unite source code modules and compiled (binary) modules in your script project. Moreover, you can 
  add full compiled script to the script project.
. Build the code explorer tree.
. Customize compilation process and error handling.
. Use scripter in the debugger mode (breakpoints, step into, trace over, run to cursor). The component 
  comes with full source code of paxScript IDE, so you can use it as a base to develop your own 
  integrated environment.

Source code of the paxScript interpreter and TPaxScripter component is written entirely with Delphi 
and compatible with  Delphi 5, Delphi 6, Delphi 7, C++ Builder 5, C++ Builder 6, Kylix 3.
You don't need any extra DLLs or OCXs.

TPaxScripter component is thread safe. It has small footprint (about 30-40 Kb per extra TPaxScripter
instance).


New:

- Increased speed of loading compiled scripts. 
- TPaxScripter.OnLoadDll event. 
- TPaxScripter.IsExecutableSourceLine method. 
- TPaxScripter.RegisterVirtualObject method.
- CreateScriptObjectEx function (PAX_RTTI unit).
- Conditional breakpoints.



