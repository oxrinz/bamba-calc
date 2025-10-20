(load "test.lisp")

(defstruct lvar
  name)

(defstruct labs
  param
  body)

(defstruct lapp
  func
  arg)

(defun print-lambda (lam)
  (cond
   ((lapp-p lam)
     (princ "(")
     (print-lambda (lapp-func lam))
     (print-lambda (lapp-arg lam))
     (princ ")"))
   ((labs-p lam)
     (princ "λ")
     (princ (string-downcase (symbol-name (lvar-name (labs-param lam)))))
     (princ ".")
     (print-lambda (labs-body lam)))
   ((lvar-p lam)
     (princ (string-downcase (symbol-name (lvar-name lam)))))))

(defun reduce-lambda (lam)
  (labels
      ((replace-abs (param expr replace-with)
                    (cond
                     ((labs-p expr)
                       (if (equal (lvar-name (labs-param expr)) (lvar-name param))
                        expr
                        (make-labs
                          :param (labs-param expr)
                          :body (replace-abs param (labs-body expr) replace-with))))

                     ((lapp-p expr)
                       (make-lapp
                         :func (replace-abs param (lapp-func expr) replace-with)
                         :arg (replace-abs param (lapp-arg expr) replace-with)))

                     ((lvar-p expr)
                       (if (eq (lvar-name expr) (lvar-name param))
                           replace-with
                           expr)))))
    (cond
     ((lapp-p lam)
       (let ((func (lapp-func lam))
             (arg (lapp-arg lam)))
         (if (labs-p func)
             (replace-abs (labs-param func)
                          (labs-body func)
                          arg)
             (make-lapp
               :func (reduce-lambda func)
               :arg arg))))

     ((labs-p lam)
       (make-labs
         :param (labs-param lam)
         :body (reduce-lambda (labs-body lam))))

     ((lvar-p lam) lam))))