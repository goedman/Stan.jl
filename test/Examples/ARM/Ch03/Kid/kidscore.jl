######### ARM Ch03: kid score example  ###########

using StanSample, Test

kid = "
data {
  int<lower=0> N;
  vector[N] kid_score;
  vector[N] mom_hs;
  vector[N] mom_iq;
}
parameters {
  vector[3] beta;
  real<lower=0> sigma;
}
model {
  kid_score ~ normal(beta[1] + beta[2] * mom_hs + beta[3] * mom_iq, sigma);
}
"

kiddata = Dict("N" => 434,
  "kid_score" => [65, 98, 85, 83, 115, 98, 69, 106, 102, 95, 91, 58, 84, 78, 102,
  110, 102, 99, 105, 101, 102, 115, 100, 87, 99, 96, 72, 78, 77, 98, 69, 130, 109,
  106, 92, 100, 107, 86, 90, 110, 107, 113, 65, 102, 103, 111, 42, 100, 67, 92,
  100, 110, 56, 107, 97, 56, 95, 78, 76, 86, 79, 81, 79, 79, 56, 52, 63, 80, 87,
  88, 92, 100, 94, 117, 102, 107, 99, 73, 56, 78, 94, 110, 109, 86, 92, 91, 123,
  102, 105, 114, 96, 66, 104, 108, 84, 83, 83, 92, 109, 95, 93, 114, 106, 87, 65,
  95, 61, 73, 112, 113, 49, 105, 122, 96, 97, 94, 117, 136, 85, 116, 106, 99, 94,
  89, 119, 112, 104, 92, 86, 69, 45, 57, 94, 104, 89, 144, 52, 102, 106, 98, 97,
  94, 111, 100, 105, 90, 98, 121, 106, 121, 102, 64, 99, 81, 69, 84, 104, 104,
  107, 88, 67, 103, 94, 109, 94, 98, 102, 104, 114, 87, 102, 77, 109, 94, 93, 86,
  97, 97, 88, 103, 87, 87, 90, 65, 111, 109, 87, 58, 87, 113, 64, 78, 97, 95, 75,
  91, 99, 108, 95, 100, 85, 97, 108, 90, 100, 82, 94, 95, 119, 98, 100, 112, 136,
  122, 126, 116, 98, 94, 93, 90, 70, 110, 104, 83, 99, 81, 104, 109, 113, 95, 74,
  81, 89, 93, 102, 95, 85, 97, 92, 78, 104, 120, 83, 105, 68, 104, 80, 120, 94,
  81, 101, 61, 68, 110, 89, 98, 113, 50, 57, 86, 83, 106, 106, 104, 78, 99, 91,
  40, 42, 69, 84, 58, 42, 72, 80, 58, 52, 101, 63, 73, 68, 60, 69, 73, 75, 20, 56,
  49, 71, 46, 54, 54, 44, 74, 58, 46, 76, 43, 60, 58, 89, 43, 94, 88, 79, 87, 46,
  95, 92, 42, 62, 52, 101, 97, 85, 98, 94, 90, 72, 92, 75, 83, 64, 101, 82, 77,
  101, 50, 90, 103, 96, 50, 47, 73, 62, 77, 64, 52, 61, 86, 41, 83, 64, 83, 116,
  100, 42, 74, 76, 92, 98, 96, 67, 84, 111, 41, 68, 107, 82, 89, 83, 73, 74, 94,
  58, 76, 61, 38, 100, 84, 99, 86, 94, 90, 50, 112, 58, 87, 76, 68, 110, 88, 87,
  54, 49, 56, 79, 82, 80, 60, 102, 87, 42, 119, 84, 86, 113, 72, 104, 94, 78, 80,
  67, 104, 96, 65, 64, 95, 56, 75, 91, 106, 76, 90, 108, 86, 85, 104, 87, 41, 106,
  76, 100, 89, 42, 102, 104, 59, 93, 94, 76, 50, 88, 70],
  "mom_hs" => [1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1,
  1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1,
  1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1,
  1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1,
  0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0,
  1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1,
  1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0,
  1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0,
  0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
  0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1,
  0, 0, 0, 1, 0, 1, 1],
  "mom_iq" => [121.117528602603, 89.3618817100663, 115.443164881725,
  99.4496394360723, 92.7457099982118, 107.901837758501, 138.893106071162,
  125.145119475328, 81.6195261789843, 95.0730686206496, 88.5769977185567,
  94.8597081943671, 88.9628008509596, 114.114297012333, 100.534071915245,
  120.419145591086, 114.426876891447, 111.592357580831, 133.849227208159,
  97.2648010634673, 110.09680614075, 126.72399416984, 97.9115903092628,
  99.9257251603133, 97.5950080521511, 121.748013460479, 98.7480786989934,
  97.9152543291671, 80.3585564632336, 114.307860633927, 109.138316302971,
  101.817179733939, 117.965104313227, 108.633496913048, 96.528619145464,
  92.8713754661642, 95.8981342875886, 107.015457730577, 87.1970117452858,
  89.3618817100663, 102.530987846246, 130.166860235388, 83.4141025980336,
  125.75346623026, 85.8103765615827, 126.520072628695, 79.203048104857,
  113.165907175696, 110.33138786508, 99.4092237400546, 102.425526488872,
  124.900437749856, 94.8597081943671, 92.3685645501674, 101.817179733939,
  79.8335329627323, 96.226139267492, 82.3554723942338, 76.5756473159814,
  110.013482886319, 111.592357580831, 113.657407368227, 101.164556773121,
  101.341094009698, 101.698163476419, 98.8191545781969, 93.4981963041352,
  87.2938898998626, 87.316028002806, 86.2094574206895, 89.8379674343074,
  121.870014908527, 127.544378629405, 109.991344783376, 90.4463141892395,
  88.8949026973177, 113.046890918176, 78.0131542683097, 95.3896508777613,
  83.6164421099846, 86.2462806103944, 95.3896508777613, 111.252314499127,
  127.014435946011, 89.951950871924, 99.2731021994947, 81.1655785576865,
  110.52128746677, 136.493846917085, 123.862011656634, 134.602392343459,
  91.0989371500582, 103.269371773029, 126.287072933559, 127.544378629405,
  92.4738903034255, 84.7940885713045, 100.534071915245, 108.003012055173,
  78.8071449713118, 121.117528602603, 103.056011346747, 100.437193760669,
  88.5548596156134, 85.3055571716597, 119.448617651507, 90.5517755466136,
  96.3340383364003, 127.644920803886, 119.856558886853, 112.018920897562,
  92.5143059994432, 96.023799755541, 91.4168421288192, 103.07814944969,
  100.243630139074, 89.8158293313641, 115.057361749322, 96.650620593512,
  105.577950778248, 97.7216907075729, 131.835771186485, 101.817179733939,
  93.4981963041352, 104.026539286327, 103.708634307566, 107.368863177393,
  92.5511291891481, 94.4425837627742, 93.1447908573186, 83.4141025980336,
  71.037405135663, 127.66705890683, 115.687846607198, 90.9762568726337,
  132.865336903467, 72.5022963925581, 100.710609151823, 132.688799666889,
  98.5457391870425, 115.665708504254, 117.062799760565, 136.493846917085,
  106.548478717828, 134.126306619218, 104.657024144202, 99.3785635568688,
  100.437193760669, 89.5253875551931, 120.92294779354, 113.143769072753,
  126.414746875437, 122.737163481443, 115.375266728083, 91.6067417305091,
  88.6603209729875, 107.178963575703, 104.969604023316, 103.8630334412,
  110.09680614075, 88.4543174411322, 117.032139577379, 125.656588075683,
  122.601041940883, 121.049630448962, 93.1447908573186, 99.3785635568688,
  123.892807443936, 113.043226898272, 115.771169861628, 114.938345491802,
  93.6208765815597, 121.748013460479, 90.3494360346627, 83.4104385781293,
  99.4864626257772, 113.910375471188, 97.5950080521511, 89.8158293313641,
  119.584739192066, 97.3816476258686, 84.8774118257353, 102.328648334295,
  99.2731021994947, 99.0750497482455, 96.9277000045708, 108.313250636032,
  100.534071915245, 99.4864626257772, 113.987614356911, 92.7702011694918,
  88.0298361151122, 106.111557481547, 103.232548583324, 99.295240302438,
  106.742042339422, 99.1725600250135, 102.447664591815, 92.8677114462598,
  116.826136045524, 85.4245734291798, 115.565166329773, 113.174564860055,
  106.861058596942, 95.8302361339468, 77.1092540192799, 89.2908058308629,
  112.412742040396, 110.643967744195, 109.537397162078, 107.901837758501,
  104.969604023316, 107.682765778157, 109.466321282875, 133.532644951047,
  128.80901236506, 101.270018130495, 87.316028002806, 118.090769781179,
  120.255639745959, 90.3457720147583, 79.9046088419358, 136.577170171515,
  102.425526488872, 132.688799666889, 96.2972151466954, 118.209786038699,
  118.090769781179, 101.504599854825, 94.3346846938659, 84.67140829388,
  86.7688663993614, 129.245933601341, 127.781042344446, 106.861058596942,
  105.754488014826, 117.032139577379, 119.35173949693, 102.765569570576,
  108.205351567124, 126.414746875437, 101.90050298837, 99.1562556370934,
  91.8127452623644, 84.1414656104858, 84.3548260367683, 79.1197248504261,
  91.4168421288192, 90.4463141892395, 79.0007085929061, 109.263981770924,
  76.7521845525589, 97.5950080521511, 128.80901236506, 113.657407368227,
  114.206686337254, 112.513284214877, 75.3368157031739, 81.5226480244075,
  102.638886915154, 101.186694876064, 112.222842438706, 123.408064035336,
  86.5665268874105, 100.116947483653, 102.328648334295, 87.9465128606813,
  80.2580142887524, 80.2580142887524, 91.0767990471149, 85.5789725628141,
  113.165907175696, 112.05933659358, 101.270018130495, 81.8328866052668,
  81.0945026784831, 81.3290844028133, 120.609045192776, 102.447664591815,
  90.9762568726337, 103.708634307566, 102.328648334295, 121.870014908527,
  88.6603209729875, 90.0291897576466, 83.5331188555537, 91.9206443312728,
  87.1933477253815, 80.4640178206077, 84.3180028470634, 77.7397388771553,
  82.272149139803, 77.3826694104343, 89.715287156883, 79.9046088419358,
  82.1531328822829, 80.2616783086568, 77.3826694104343, 82.7836177401583,
  89.2074825764321, 89.088466318912, 88.9872920222396, 118.923594151005,
  83.8510238343148, 84.044587455909, 105.052927277747, 107.999348035269,
  97.3816476258686, 103.791957561996, 97.5950080521511, 88.6603209729875,
  107.246861729345, 89.8379674343074, 108.906912304203, 100.63953327262,
  118.840270896574, 95.5123311551858, 84.7719504683612, 100.747432341528,
  87.0034481236916, 77.8587551346754, 85.3018931517554, 92.7702011694918,
  74.8607299789328, 115.248584072661, 107.372527197298, 102.202982866342,
  97.9115903092628, 96.8566241253673, 111.465674925409, 109.466321282875,
  82.2500110368597, 92.7702011694918, 115.568830349677, 84.044587455909,
  116.199315207553, 99.295240302438, 87.1933477253815, 76.7117688565413,
  80.6985995449379, 82.4633714631422, 85.1798917037074, 93.0737149781151,
  88.5769977185567, 103.056011346747, 86.8767654682698, 97.9152543291671,
  120.92294779354, 91.7294220079335, 87.5072503261452, 90.4463141892395,
  84.1636037134291, 96.6542846134164, 95.703553478525, 88.7682200418959,
  92.1397163116164, 108.003012055173, 80.3893522505354, 99.8030448828889,
  90.0291897576466, 93.9387815603207, 103.708634307566, 77.1092540192799,
  117.55716307788, 79.8335329627323, 83.6164421099846, 88.731396852191,
  82.7836177401583, 86.8767654682698, 88.731396852191, 92.2408906082888,
  90.5517755466136, 84.1414656104858, 93.0737149781151, 85.8348677328627,
  98.8559777679018, 95.5123311551858, 101.067678618544, 85.9323780096308,
  82.7836177401583, 98.6647554445626, 82.1494688623785, 85.6157957525191,
  79.4376298291872, 75.3368157031739, 80.8921631665322, 115.771169861628,
  97.1591040033394, 80.8921631665322, 79.505527982829, 98.0121324837439,
  108.866496608185, 80.6985995449379, 100.747432341528, 91.0989371500582,
  82.9859572521092, 89.715287156883, 131.010705519546, 124.514634617453,
  91.6104057504134, 92.9903917236843, 91.8838211415678, 88.6909811561733,
  126.093509311965, 84.9853108946437, 82.9859572521092, 101.795041630996,
  100.243630139074, 110.013482886319, 88.5769977185567, 106.742042339422,
  95.2921406009932, 108.313250636032, 110.33138786508, 116.829800065428,
  86.6855431449306, 96.8566241253673, 90.2482617379903, 89.2908058308629,
  74.2302451210575, 91.8838211415678, 96.4607209918222, 97.4037857288119,
  131.533291308512, 78.2445582670783, 127.675716591188, 124.514634617453,
  80.4640178206077, 74.8607299789328, 84.8774118257353, 92.9903917236843,
  94.8597081943671, 96.8566241253673, 91.2533362836924],
  "mom_hs_new" => 1,
  "mom_iq_new" => 100)

sm = SampleModel("kid", kid);

rc = stan_sample(sm, data=kiddata)

if success(rc)
  samples = read_samples(sm)

  # Fetch the cmdstan summary.
  
  df = read_summary(sm)
  @test df[df.parameters .== Symbol("beta[1]"), :mean][1] ≈ 25.5 rtol=0.1
  @test df[df.parameters .== Symbol("beta[2]"), :mean][1] ≈ 6.01 rtol=0.1
  @test df[df.parameters .== Symbol("beta[3]"), :mean][1] ≈ 0.565 rtol=0.1
  @test df[df.parameters .== Symbol("sigma"), :mean][1] ≈ 18.2 rtol=0.1
end
