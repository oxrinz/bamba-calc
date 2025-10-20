; (λx.x)
(defparameter id
  (make-labs :param (make-lvar :name 'x)
             :body (make-lvar :name 'x)))

; (λx.(x x))
(defparameter self-app
  (make-labs :param (make-lvar :name 'x)
             :body (make-lapp
                    :func (make-lvar :name 'x)
                    :arg (make-lvar :name 'x))))

; ((λx.(x x)) (λx.(x x)))
(defparameter omega
  (make-lapp :func self-app :arg self-app))

; (λx.(λy.x))
(defparameter const
  (make-labs :param (make-lvar :name 'x)
             :body (make-labs :param (make-lvar :name 'y)
                              :body (make-lvar :name 'x))))

; ((λx.(λy.x)) a)
(defparameter const-a
  (make-lapp :func const
             :arg (make-lvar :name 'a)))

; (((λx.(λy.x)) a) b)
(defparameter const-a-b
  (make-lapp :func const-a
             :arg (make-lvar :name 'b)))

; ((λx.x) y)
(defparameter id-y
  (make-lapp :func id
             :arg (make-lvar :name 'y)))

; ((λx.(λy.y)) z)
(defparameter double-id
  (make-lapp :func (make-labs :param (make-lvar :name 'x)
                              :body (make-labs :param (make-lvar :name 'y)
                                               :body (make-lvar :name 'y)))
             :arg (make-lvar :name 'z)))

; (λx.(λy.(x y)))
(defparameter apply-n
  (make-labs :param (make-lvar :name 'x)
             :body (make-labs :param (make-lvar :name 'y)
                              :body (make-lapp
                                     :func (make-lvar :name 'x)
                                     :arg (make-lvar :name 'y)))))

; ((λx.(λy.(x y))) f)
(defparameter apply-f
  (make-lapp :func apply-n
             :arg (make-lvar :name 'f)))

; ((λx.(λy.(x y))) (λz.z)) w
(defparameter apply-id-w
  (make-lapp :func apply-f
             :arg (make-lvar :name 'w)))

; ((λx. (λx. x)) y)
(defparameter shadow-test
  (make-lapp
   :func (make-labs :param (make-lvar :name 'x)
                    :body (make-labs :param (make-lvar :name 'x)
                                     :body (make-lvar :name 'x)))
   :arg (make-lvar :name 'y)))