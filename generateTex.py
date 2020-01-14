import csv
with open('outputs/profiles.csv', newline='') as csvfile:
    prof = csv.reader(csvfile)
    with open('report/figs.tex', 'w') as texfile:
        for row in prof:
          if not '发布' in row[3]:
            continue
          print(f'''
\\begin{{figure}}
  \centering
  \includegraphics[width=0.9\linewidth]{{{row[3]}.png}}
  \caption{{"{row[3]}"公众号各主题下推送传播效力分布}}
  \label{{fig:{row[3]}-box}}
\end{{figure}}''', file=texfile)
