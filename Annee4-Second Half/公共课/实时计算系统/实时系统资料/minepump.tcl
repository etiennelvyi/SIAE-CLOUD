#############################################################
# minepump.tcl
# Fichier Tcl/Tk fournissant les primitives graphiques d'une
# mine avec pompe
# Emmanuel Grolleau
# Derniere modification 02/04/2015
##############################################################

# On commence par la definition de diverses constantes et variables
set minepump(width) 250
# Largeur de la cuve
set minepump(height) 200
# Hauteur de la cuve
set minepump(graduate) 20
# Ecart entre chaque graduation du niveau d'eau
set minepump(HLS) 150
# Position du capteur haut HLS dans la cuve
set minepump(LLS) 80
# Position du capteur bas LLS dans la cuve
set minepump(level) 100
# Niveau initial de l'eau
set minepump(min_methan) 50
# Niveau minimum que l'utilisateur peut donner au methane
set minepump(max_methan) 180
# Niveau maximum que l'utilisateur peut donner au methane
set minepump(infiltration) 1
# Niveau d'infiltration
set minepump(max_infiltration) 10
# Niveau maximum que l'utilisateur peut donner a l'infiltration
set minepump(pumpflow) 2
# Niveau de pompage de la pompe
set minepump(max_pumpflow) 15
# Niveau maximum que l'utilisateur peut donner a la pompe
set EXIT 0
# Variable mise a 1 lorsque l'application est detruite par l'utilisateur
if {[catch {socket -server acceptcx 4242}]} {
	tk_messageBox -icon error -title "Erreur d'initialisation" -message "Erreur lors de la création du serveur TCP port 4242\nVérifiez qu'un autre simulateur ne tourne pas déjà!!!"
	exit
}

proc trace {txt} {
	#catch {console show}
	#puts $txt
}

proc acceptcx {ch radr rport} {
	Reset
	fconfigure $ch -translation {auto binary}
	fileevent $ch readable "readcx $ch"
	trace "Connexion de $radr"
}

proc Reset {} {
	global minepump
	SetPump 0
	SetAlarm 0
	ChangeWaterLevel [expr 100-$minepump(level)]
}


proc readcx {ch} {
	set cmd [gets $ch]
	switch -regexp -- $cmd {
		{HLS.*} {puts -nonewline $ch [binary format c [GetHLS]];flush $ch}
		{LLS.*} {puts -nonewline $ch [binary format c [GetLLS]];flush $ch}
		{MS.*} {puts -nonewline $ch [binary format c [GetMethanLevel]];flush $ch}
		{Pump[ \t]+[01].*} {SetPump [lindex $cmd 1]}
		{Alarm[ \t]+[01].*} {SetAlarm [lindex $cmd 1]}
		default {close $ch}
	}
}

proc ChangeWaterLevel {v} {
# Fait evoluer le niveau de l'eau de avec la pompe ouverte (si v=-1)
# ou fermee (si v=1)
  global minepump
  if {$v>0} {
  # Si v est positif, la pompe est fermee
    set dy [expr $v*$minepump(infiltration)]
    # Le niveau de l'eau n'est modifie que par l'infiltration
  } else {
  # Sinon, la pompe est ouverte
    set dy [expr $v*($minepump(pumpflow)-$minepump(infiltration))]
    # le niveau de l'eau est modifie par la conjonction de l'infiltration
    # et de la pompe
  }
  foreach {x1 y1 x2 y2} [$minepump(canvas) coords $minepump(water_id)] {}
  $minepump(canvas) coords $minepump(water_id) $x1 [expr $y1-$dy] $x2 $y2
  # On modifie le rectangle qui represente l'eau
  incr minepump(level) $dy
  # On memorise le nouveau niveau d'eau
  AdjustCaptors
  # On fait travailler les capteurs
}
proc GetHLS {} {
# Renvoie 1 si le capteur HLS est immerge, 0 sinon, de plus, met cette valeur
# dans la variable globale HLS, qui pourra ainsi etre recuperee, par exemple,
# dans Ada
  global minepump HLS
  set HLS $minepump(hls)
  return $HLS
}
proc GetLLS {} {
# Renvoie 1 si le capteur LLS est immerge, 0 sinon, de plus, met cette valeur
# dans la variable globale LLS, qui pourra ainsi etre recuperee, par exemple,
# dans Ada
  global minepump LLS
  set LLS $minepump(lls)
  return $LLS
}
proc SetPump {v} {
# Represente graphiquement l'ouverture de la pompe
  global minepump PUMP
  if {$v} {
	$minepump(canvas) itemconfigure $minepump(pump_id) -fill blue
	set PUMP 1
  } else {
	$minepump(canvas) itemconfigure $minepump(pump_id) -fill gray
	set PUMP 0
  }
}
proc GetMethanLevel {} {
# Renvoie le niveau de methane, de plus, met cette valeur
# dans la variable globale METHAN, qui pourra ainsi etre recuperee, par exemple,
# dans Ada
  global minepump METHAN
  #set METHAN [$minepump(scale) get]
  if {$METHAN>255} {return 255}
  return $METHAN
}
proc SetAlarm {v} {
# Affiche l'alarme
  global minepump
  if {$v} {
    $minepump(alarmcanvas) itemconfigure $minepump(alarm) -fill red
    $minepump(alarmcanvas) itemconfigure $minepump(alarmtext) -text ALARM
  } else {
    $minepump(alarmcanvas) itemconfigure $minepump(alarm) -fill green
    $minepump(alarmcanvas) itemconfigure $minepump(alarmtext) -text OK
  }
}
proc AdjustCaptors {} {
# Met les capteurs d'eau a jour
  global minepump
  if {$minepump(level)>$minepump(HLS)} {
    set minepump(hls) 1
  } else {
    set minepump(hls) 0
  }
  if {$minepump(level)>$minepump(LLS)} {
    set minepump(lls) 1
  } else {
    set minepump(lls) 0
  }
}
proc ShowCanvas {parent} {
# Affiche la cuve et la pompe, ainsi que l'eau...
  global minepump
  set w $parent.mine
  set minepump(canvas) $w
  # Creation du canvas
  canvas $w -bg white -width [expr 60+$minepump(width)] \
    -height [expr 40+$minepump(height)]
  # Creation de la cuve
  $w create line 40 30 40 [expr 30+$minepump(height)] \
    [expr 40+$minepump(width)] [expr 30+$minepump(height)] \
    [expr 40+$minepump(width)] 30
  # Creation du liquide
  set minepump(water_id) [$w create rectangle \
    40 [expr $minepump(height)+30] [expr 40+$minepump(width)] \
    [expr 30+$minepump(height)-$minepump(level)] -fill blue -stipple gray25 -width 0]
  # Creation de la pompe
  set minepump(pump_id) [$w create rectangle \
    [expr 40+$minepump(width)/10] [expr $minepump(height)+28] \
    [expr 45+$minepump(width)/10] 0 -width 1 -outline black -fill gray]
  # Creation des graduations
  set y [expr 30+$minepump(height)]
  for {set i 0} {$i<[expr $minepump(height)/$minepump(graduate)]} {incr i} {
    $w create line 40 $y 50 $y -fill black
    set txt [$w create text 40 $y -anchor e -text [expr $i*$minepump(graduate)]]
    catch {$w itemconfigure $txt -font {times 10}}
    incr y -$minepump(graduate)
  }
  # Creation du niveau haut
  $w create line [expr 20+$minepump(width)] \
    [expr $minepump(height)+30-$minepump(HLS)] \
    [expr 40+$minepump(width)] \
    [expr $minepump(height)+30-$minepump(HLS)] \
    -fill red
  # Creation du niveau bas
  $w create line [expr 20+$minepump(width)] \
    [expr $minepump(height)+30-$minepump(LLS)] \
    [expr 40+$minepump(width)] \
    [expr $minepump(height)+30-$minepump(LLS)] \
    -fill red
  AdjustCaptors
  return $w
}

proc ShowScale {parent} {
  # Affiche une regle permettant a l'utilisateur de modifier le niveau de
  # methane
  global minepump METHAN
  set w $parent.scale
  frame $w
  pack [label $w.l -text "Methan"] -side left
  pack [scale $w.s -from $minepump(min_methan) -to $minepump(max_methan) \
    -resolution 1 -showvalue 1 -orient horizontal -variable METHAN] -side left
  set minepump(scale) $w.s
  return $w
}

proc ShowAlarm {parent} {
  # Affiche l'ecran d'alarme, au depart, l'alarme n'est pas affichee
  global minepump
  set w $parent.alarm
  canvas $w -width 60 -height 60 -borderwidth 0
  set minepump(alarmcanvas) $w
  set minepump(alarm) [$w create polygon 20 0 40 0 60 20 60 40 40 60 20 \
    60 0 40 0 20 -fill green]
  set minepump(alarmtext) [$w create text 30 30 -anchor center -text OK]
  return $w
}

proc ShowDebit {parent} {
# Affiche une regle qui permettra a l'utilisateur de regler le debit de
# la pompe, ainsi que le debit d'infiltration
  global minepump
  set w $parent.debit
  frame $w
  pack [label $w.l -text "Infiltration"] -side left
  pack [scale $w.s -from 0 -to $minepump(max_infiltration) \
    -resolution 1 -showvalue 1 -orient horizontal -variable minepump(infiltration)] -side left
  pack [label $w.l2 -text "Pump flow"] -side left
  pack [scale $w.s2 -from 0 -to $minepump(max_pumpflow) \
    -resolution 1 -showvalue 1 -orient horizontal -variable minepump(pumpflow)] -side left
  return $w
}

proc ShowWindow {} {
  # Affiche la fenetre principale
  wm title . "Mine Pump"
  wm protocol . WM_DELETE_WINDOW "set EXIT 1;destroy ."
  pack [ShowAlarm ""] -side top
  pack [ShowCanvas ""] -side top
  pack [ShowScale ""] -side top
  pack [ShowDebit ""] -side top
}


proc Simulate {} {
  global PUMP
  if {$PUMP} {
	ChangeWaterLevel -1
  } else {
	ChangeWaterLevel 1
  }
  after 200 Simulate
}
set PUMP 0
#console show
ShowWindow
Simulate
