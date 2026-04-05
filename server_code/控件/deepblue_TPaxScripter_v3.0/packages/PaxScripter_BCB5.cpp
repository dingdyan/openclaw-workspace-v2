//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("PaxScripter_BCB5.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("PaxScripterRegister.pas");
USERES("paxscripter.dcr");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
