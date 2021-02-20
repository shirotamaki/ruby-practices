#!/usr/bin/env ruby
# frozen_string_literal: true

# ARGVを使い引数を受けれるようにする。
score = ARGV[0]
# 得られる結果： 0,10,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5
# 課題内容変更　=> （スペアは最初から、[0,10]にしてある。　

scores = score.split(',')
# 得られる結果：["0", "10", "9", "0", "0", "3", "8", "2", "7", "3", "X", "9", "1", "8", "0", "X", "6", "4", "5"]

# shotsへ配列にし代入する。上記の配列の「X」を「10」に変換し代入。「それ以外」を整数へ変換する。
shots = []
scores.each do |s|
  shots << if s == 'X'
             10
           else
             s.to_i
           end
end
# 得られる結果：[0, 10, 9, 0, 0, 3, 8, 2, 7, 3, 10, 9, 1, 8, 0, 10, 6, 4, 5]

# 初期値を設定
shot_count = 0 # 投球数をカウント
frame_count = 1 # フレーム数をカウント
frame_score = 0 # 1フレームごとの合計スコア
total_score = 0 # 全フレームの合計スコア

shots.each_with_index do |s, idx|
  shot_count += 1 # 1投プラスする
  frame_score += s # 都度、スコア「s」をプラスしていく

  # 10フレームの計算
  if frame_count == 10 && shot_count == 1 && s == 10
    total_score += frame_score + shots[idx + 1] + shots[idx + 2] # 10フレーム目の1投目がストライクの場合、次と次々の分もプラス
    break # 脱出してこれ以降のコードを無視
  elsif frame_count == 10 && frame_score == 10
    total_score += frame_score + shots[idx + 1] # 10フレーム目でスペアが出た場合、次の分もプラス
    break # 脱出してこれ以降のコードを無視
  end

  # 1〜9フレームの計算
  if shot_count == 1 && s == 10 # ストライクの時
    total_score += shots[idx + 1] + shots[idx + 2] # ボーナスポイントを加算、次と次々の投球スコアを加算
    shot_count += 1 # ストライクだと1投目扱いになるので　プラスして2投目として揃える
  elsif frame_score == 10 # 1フレームの合計数が10の時（スペア）
    total_score += shots[idx + 1] # ボーナスポイントを加算。次の投球スコアを加算
  end

  next if shot_count != 2 # if !=　もし〜ではなかったら。1投目はtrueになるのでnextする。2投目になったら以下を追加する。（falseなのでnextは実行されない）

  total_score += frame_score # frame_scoreで加算していたスコアを、合計スコアにまとめる
  frame_count += 1 # フレームを1追加する（次のフレームへ行く）
  frame_score = 0 # フレームのスコアを0にリセットする
  shot_count = 0 # 投球数を0にリセットする
end

p total_score
