
/* 5次の魔方陣 */
param n := 5;

/* 各行・列・ナナメの和 from Wikipedia */
param sum_for_n:= n * (n * n +1) / 2;

/* よく使う集合を定義 */
set N := {1..n};
set N2 := {1..n*n};

/* 変数 x[i,j,k] = 1 <=> (i,j)にkが入る */
var x{N, N, 1..n*n}, binary;

/* (i,j)には1つの数しか入らない */
s.t. a{(i,j) in {N,N}}: sum{k in N2} x[i,j,k] = 1;

/* 1つの数は1箇所でしか使えない */
s.t. b{k in N2}: sum{(i,j) in {N,N}} x[i,j,k] = 1;

/* 横に足すとある値 */
s.t. sum_col{i in N}: sum{(j,k) in {N,N2}} k * x[i,j,k] = sum_for_n;

/* 縦に足すとある値 */
s.t. sum_row{j in N}: sum{(i,k) in {N,N2}} k * x[i,j,k] = sum_for_n;

/* 左上から右下にナナメに足すとある値 */
s.t. sum_dia1: sum{(i,k) in {N,N2}} k * x[i,i,k] = sum_for_n;

/* 右上から左下にナナメに足すとある値 */
s.t. sum_dia2: sum{(i,k) in {N,N2}} k * x[i,n-i+1,k] = sum_for_n;

/* http://blog.unfindable.net/archives/7179 からの工夫 */

/* 回転・裏返し防止 */
s.t. tl_lt_tr: sum{k in N2} k * x[1,1,k] <= sum{k in N2} k * x[1,n,k] - 1;
s.t. tr_lt_bl: sum{k in N2} k * x[1,n,k] <= sum{k in N2} k * x[n,1,k] - 1;
s.t. tl_lt_br: sum{k in N2} k * x[1,1,k] <= sum{k in N2} k * x[n,n,k] - 1;

/* (1,1)が22以下なのは上の式から導かれるので不要 */


/* 親子方陣 from Wikipedia */
/* 子方陣の和は39という法則がありそうだが証明できないので使えない */

/* 整数変数版
var sum_for_3, integer, >= 0;

s.t. sum_col_3{i in 2..n-1}: sum{(j,k) in {2..n-1,N2}} k * x[i,j,k] = sum_for_3;
s.t. sum_row_3{j in 2..n-1}: sum{(i,k) in {2..n-1,N2}} k * x[i,j,k] = sum_for_3;
s.t. sum_dia3_1: sum{(i,k) in {2..n-1,N2}} k * x[i,i,k] = sum_for_3;
s.t. sum_dia3_2: sum{(i,k) in {2..n-1,N2}} k * x[i,n-i+1,k] = sum_for_3;
*/


/* binary変数版 
 * 全部左上から右下のナナメの和と一致するよう定式化
 */
s.t. sum_col_3{i in 2..n-1}: sum{(j,k) in {2..n-1,N2}}k * x[i,j,k] = sum{(i2,k) in {2..n-1,N2}}k*x[i2,i2,k];
s.t. sum_row_3{j in 2..n-1}: sum{(i,k) in {2..n-1,N2}}k * x[i,j,k] = sum{(i2,k) in {2..n-1,N2}}k*x[i2,i2,k];
s.t. sum_dia3_2: sum{(i,k) in {2..n-1,N2}}k * x[i,n-i+1,k] = sum{(i2,k) in {2..n-1,N2}}k*x[i2,i2,k];

s.t. c13: x[3,3,13] = 0;


solve;

/* 表示 */
for {i in 1..n}
{  for {j in 1..n} printf " %2d", sum{k in N2} k*x[i,j,k];
   printf("\n");
}

end;

