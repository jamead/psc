# main tcl to configure the FreeRTOS SW project

proc init {} {
  # set Source path
  # it defaults to src/, but for combined hw & sw projects, use
  # src/hw/ and src/sw/
  set ::fwfwk::SrcPath ${::fwfwk::ProjectPath}/src/sw

  addSrcModule user_app ${::fwfwk::ProjectPath}/src/sw/tcl/main.tcl
}

proc doOnCreate {} {

}

proc doOnBuild {} {

}

proc doPostBuild {} {

  #::fwfwk::printInfo "Creating image bin file..."

  #set fsblElf  [::fwfwk::utils::findFiles ${::fwfwk::WorkspacePath}/${::fwfwk::PlatformName}/export/  boot/fsbl.elf]
  #set pmufwElf [::fwfwk::utils::findFiles ${::fwfwk::WorkspacePath}/${::fwfwk::PlatformName}/export/  boot/pmufw.elf]
  #set bitFile  [::fwfwk::utils::findFiles ${::fwfwk::WorkspacePath}/${::fwfwk::PlatformName}/export/  *.bit]
  #set appElf   [::fwfwk::utils::findFiles ${::fwfwk::WorkspacePath}/${::fwfwk::AppName} ${::fwfwk::AppName}.elf]

  #set bifFileName ${::fwfwk::ProjectPath}/out/${::fwfwk::PrjBuildName}.bif
  #set bifFile [open $bifFileName w]

  #puts $bifFile "the_ROM_image:"
  #puts $bifFile "\{"
  #puts $bifFile "  \[bootloader, destination_cpu=a53-0\] $fsblElf"
  #puts $bifFile "  \[destination_cpu=pmu\] $pmufwElf"
  #puts $bifFile "  \[destination_device=pl\] $bitFile"
  #puts $bifFile "  \[destination_cpu=a53-0\] $appElf"
  #puts $bifFile "\}"

  #close $bifFile

  #if {[set result \
  #       [catch {exec bootgen -arch zynqmp -image $bifFileName -w -o i ${::fwfwk::ProjectPath}/out/${::fwfwk::PrjBuildName}.bin} resulttext]]} {
  #  ::fwfwk::utils::cprint $resulttext {"ERROR" -fg red -style bright}
  #  ::fwfwk::printError "bin file creation failed"
  #} else {
  #  ::fwfwk::printSuccess "Image file created: out/${::fwfwk::PrjBuildName}.bin"
  #}

}
