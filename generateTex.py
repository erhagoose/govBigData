import csv
with open('outputs/profiles.csv', newline='') as csvfile:
    prof = csv.reader(csvfile)
    with open('report/figs.tex', 'w', encoding='utf8') as texfile, open('outputs/logs.txt', 'w', encoding='utf8') as txtfile:
        for row in prof:
          if not '发布' in row[3]:
            continue
          print(f'{row[3]}', file=txtfile)
          print(f'''
\\begin{{figure}}
  \centering
  \includegraphics[width=0.9\linewidth]{{{row[3]}.png}}
  \caption{{"{row[3]}"公众号各主题下推送传播效力分布}}
  \label{{fig:{row[3]}-box}}
\end{{figure}}''', file=texfile)
