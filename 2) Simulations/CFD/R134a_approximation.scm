;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                              ;;;
;;;             Fluent USER DEFINED MATERIAL DATABASE            ;;;
;;;                                                              ;;;
;;; (name type[fluid/solid] (chemical-formula . formula)         ;;;
;;;             (prop1 (method1a . data1a) (method1b . data1b))  ;;;
;;;            (prop2 (method2a . data2a) (method2b . data2b)))  ;;;
;;;                                                              ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(
	(r134a-approx fluid
		(chemical-formula . #f)
		(density (ideal-gas . #f) (constant . 1.225) (compressible-liquid 101325 1.225 142000. 1 1.1 0.9))
		(specific-heat (polynomial piecewise-polynomial (100. 1000. 204.4020655 2.529209111 -0.001686461147 1.016106914e-06 -2.650943781e-10) (1000. 1500. 332.3650164 1.936805646 -0.0006513725053 2.112882523e-07 -3.092384541e-11)) (constant . 1006.43) (polynomial nasa-9-piecewise-polynomial (200. 1000. 2898903. -56496.26 1437.799 -1.653609 0.003062254 -2.279138e-06 6.272365e-10) (1000. 6000. 69324940. -361053.2 1476.665 -0.06138349 2.027963e-05 -3.075525e-09 1.888054e-13)))
		(thermal-conductivity (constant . 0.013))
		(viscosity (constant . 2.2e-05) (sutherland 1.716e-05 273.11 110.56) (power-law 1.716e-05 273.11 0.666) (blottner-curve-fit 0.0307 0.23 -10.8))
		(molecular-weight (constant . 102.032))
		(characteristic-vibrational-temperature (constant . 2686))
		(lennard-jones-length (constant . 3.711))
		(lennard-jones-energy (constant . 78.59999999999999))
		(thermal-accom-coefficient (constant . 0.9137))
		(velocity-accom-coefficient (constant . 0.9137))
		(formation-entropy (constant . 194336))
		(reference-temperature (constant . 298.15))
		(critical-pressure (constant . 3758000.))
		(critical-temperature (constant . 132.3))
		(acentric-factor (constant . 0.033))
		(critical-volume (constant . 0.002857))
		(electric-conductivity (constant . 1e-09))
		(dual-electric-conductivity (constant . 1e-09))
		(therm-exp-coeff (constant . 0))
		(speed-of-sound (none . #f))
	)

)
