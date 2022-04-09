#lang p5

(output-to-file "../soft-ellipse.js")

(import draw-grain fast-get fast-set kelvin-color)

(define (setup)
  (var [cnv (createCanvas windowWidth windowHeight)])
  (cnv.style "display" "block")
  (draw-grain)
  (for ([idx in-range 0 10])
    (console.log idx)
    (draw-udf (soft-circle (random 0 windowWidth)
                           (random 0 windowHeight)
                           (random 1 10))
              (kelvin-color (Math.pow 10 (random 3.3 4.3)))))
  (updatePixels))
 
#| ; test scene of binary stars
  (draw-udf (soft-circle (/ windowWidth 2)
                      (/ windowHeight 2)
                      25)
            (kelvin-color 20000))
  (draw-udf (soft-circle ( - (/ windowWidth 2) 80)
                      ( - (/ windowHeight 2) 75)
                      25)
            (kelvin-color 2850))
  (updatePixels))|#

; a udf (unbounded distance function)
; gives a scale factor for color intensity
; based on distance from the center (like an SDF).
; 1 marks the 'true color', and values above 1
; simulate overexposure
(define (soft-circle x y r)
  (lambda (ix iy)
    (let ([d (dist x y ix iy)])
      (/ (* r r) (* d d)))))
          
(define (add-color base paint intensity)
  (color
   (+ (red base)   (* intensity (red paint)))
   (+ (green base) (* intensity (green paint)))
   (+ (blue base)  (* intensity (blue paint)))))

(define (draw-udf udf draw-color)
  (for ([idx in-range 0 windowWidth])
    (for ([idy in-range 0 windowHeight])
      (let ([intensity (udf idx idy)])
        ; 255 * 0.005 = 1.275, isn't really noticeable
        ; cutoff of 0.01 gives very clear rings :(
        (when (> intensity 0.005)
          (fast-set idx idy (add-color
                             (fast-get idx idy)
                             draw-color
                             intensity)))))))
; change above 'when' to 'if' and uncomment next line
; to see drawing radii
;  (fast-set idx idy (add-color (fast-get idx idy) (color 100 0 0) 1)))))))
