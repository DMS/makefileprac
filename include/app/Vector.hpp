#ifndef PROJECT_VECTOR
#define PROJECT_VECTOR

class Vector {
    double x,y;
    public:
        Vector();
        Vector(double, double);
        Vector operator+(const Vector &other) const;
        void print();
};

#endif