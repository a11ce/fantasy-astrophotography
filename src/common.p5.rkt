#lang p5

(output-to-file "../common.js")

(import HSL RGB)

; call (loadPixels) before and (updatePixels) after use.
; translation of https://p5js.org/reference/#/p5/pixels
(define (fast-set x y col)
  (let ([d (pixelDensity)])
    (for ([i in-range 0 d])
      (for ([j in-range 0 d])
        (let ([index
               ; i think this is right...
               (* 4 (+ (* (+ j (* y d))
                          windowWidth
                          d)
                       (+ i (* x d))))])
          (:= pixels index (red col))
          (:= pixels (+ 1 index) (green col))
          (:= pixels (+ 2 index) (blue col))
          (:= pixels (+ 3 index) (alpha col)))))))

; allows for gets between screen updates
(define (fast-get x y)
  (let* ([d (pixelDensity)]
         [index (* 4 (+ (* y d
                           windowWidth
                           d)
                        (* x d)))])
    (color (ref pixels index)
           (ref pixels (+ 1 index))
           (ref pixels (+ 2 index)))))
        

; interpolation of
; http://planetpixelemporium.com/tutorialpages/light.html
(define (kelvin-color k)
  (colorMode HSL 360 100 100)
  (var (ret-col
        (color
         ; h 
         (cond
           [(<= k 5000) 32]
           [(<= k 6800) (- (* 0.1 k)
                           468)]
           [else 212])
         ; s
         100
         ; l
         (cond
           [(<= k 6000)
            (- 117 (/ 1070 (Math.sqrt (- k 1660))))]
           [else
            (+ 46 (/ 2100 (Math.sqrt (- k 4500))))]))))
  (colorMode RGB 255 255 255)
  ret-col)