#lang p5

(output-to-file "../bg-grain.js")

(import BLUR fast-set)

(define NOISE-SCALE 2)
(define NOISE-PEAK 225)

(define (noise-at x y offset)
  (* NOISE-PEAK
     (Math.pow (noise
                (* NOISE-SCALE (+ (random -5 5) x))
                (* NOISE-SCALE (+ (random -5 5) y))
                offset)
               3)))

(define (>/3 a b c)
  (and (> a b)
       (> a c)))
                    
(define (draw-grain)
  (loadPixels)
  (for ([idx in-range 0 windowWidth])
    (for ([idy in-range 0 windowHeight])
      (let ([nR (noise-at idx idy 0)]
            [nG (noise-at idx idy 0.5)]
            [nB (noise-at idx idy 1)])
        (fast-set idx idy
             (cond
               [(>/3 nR nG nB) (color nR 0 0)]
               [(>/3 nG nR nB) (color 0 nG 0)]
               [(>/3 nB nR nG) (color 0 0 nB)])))))
  (updatePixels)
  (filter BLUR 2)
  (loadPixels))
