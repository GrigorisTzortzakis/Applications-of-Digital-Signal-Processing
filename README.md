# Digital Signal Processing – CEID Exercises

This repository contains solutions and analyses for the five assigned exercises in the “Applications of Digital Signal Processing” course (CEID, Univ. of Patras). Each exercise is self‑contained in its own folder and comes with accompanying MATLAB/Python code, plots, and write‑ups.

---

##  Repository Structure:

---

## Exercise 1 – Spectral Content Estimation  
**Topic:** Pisarenko’s method for estimating sinusoidal frequencies and noise variance by eigen‑analysis of the autocorrelation matrix.  

**Key Steps & Analysis:**

1. **Theory Recap**  
   - Model the signal as  
     $$X(n) = \sum_{i=1}^{P} A_i e^{j \omega_i n} + W(n).$$  
   - Form the autocorrelation matrix  
     $$R_{XX} = E\bigl[X\,X^H\bigr],$$  
     and observe that the “signal subspace” is spanned by the eigenvectors corresponding to the $P$ largest eigenvalues, while the “noise subspace” corresponds to the $(M − P)$ smallest, equal eigenvalues.

2. **Algorithm (Pisarenko)**  
   - Compute eigenvalues  
     $$\lambda_1 \ge \lambda_2 \ge \dots \ge \lambda_M.$$  
   - Estimate the noise variance  
     $$\hat\sigma_W^2 = \lambda_{\min} = \lambda_M.$$  
   - The signal amplitudes follow from  
     $$|A_i|^2 = \frac{\lambda_i - \lambda_M}{M},\quad i=1,\dots,P.$$  
   - Recover each frequency $\omega_i$ from the phase progression of the corresponding principal eigenvector.

3. **Implementation & Results**  
   - **Part 5:** Closed‑form example with a $2\times2$ autocorrelation matrix.  
   - **Part 7:** Monte Carlo simulation ($N=100$ realizations, $M=50$), estimate sample autocorrelation, compute eigenstructure, plot histogram of noise‑subspace eigenvalues, compare empirical moments to theory.  
   - **Discussion:** Convergence of sample estimates to their theoretical values, effect of $M$ and $N$ on estimator variance, and bias‑variance trade‑offs in frequency estimation.

---


## Exercise 2 – Low‑Rank Modeling & Eigenfilters  
**Topic:** Low‑rank approximation of multidimensional signals via eigenfilter decomposition (Karhunen–Loève, PCA/SVD).  

**Key Steps & Analysis:**  
1. **Modeling**  
   - Represent vector random process \(U\) with covariance \(C_{UU}=Q\Lambda Q^T\).  
   - Transmit only the top \(P\) principal components for compression.  

2. **Noiseless vs. Noisy Channel**  
   - Derive reconstruction MSE in noise‑free case: \(\sum_{m=P+1}^M\lambda_m\).  
   - In AWGN channel, show MSE\(\;=\sum_{m=P+1}^M\lambda_m + P\sigma_W^2\).  

3. **Simulation**  
   - Load provided `U.mat` (100 realizations, M=10 000).  
   - Estimate \(C_{UU}\); perform `eig` or `svd`; verify theoretical error curves vs. P.  
   - Plot relative error vs. P for various channel SNRs; discuss regimes where low‑rank transmission helps.  

---

## Exercise 3 – Dictionary Learning & Sparse Coding (KSVD + Inpainting)  
**Topic:** KSVD algorithm for dictionary learning and sparse coding (Generalized OMP), plus applications to denoising & inpainting.  

**Key Steps & Analysis:**  
1. **KSVD & GenOMP**  
   - **P1 (Sparse Coding):** Solve \(\min_X\|Y-DX\|_F^2\) s.t. \(\|x_n\|_0\le T\) via greedy atom selection (OMP).  
   - **P2 (Dictionary Update):** Update each atom by SVD of residuals after fixing sparsity pattern.  
   - Iterate until convergence or fixed epochs.  

2. **Applications**  
   - **Denoising:** Represent noisy patches with learned dictionary → reconstruct clean image.  
   - **Inpainting:** Fill missing pixels by sparse approximation on known support.  

3. **Implementation & Results**  
   - MATLAB (and Python bonus) code for both tasks.  
   - Show side‑by‑side plots of original / degraded / recovered images.  
   - Tabulate MSE vs. SNR for denoising and inpainting scenarios; interpret how dictionary quality and sparsity level affect performance.  

---

## Exercise 4 – PCA, LDA & K‑Means for Face Recognition  
**Topic:** Eigenfaces (PCA), Fisherfaces (LDA), and K‑means clustering for face classification.  

**Key Steps & Analysis:**  
1. **PCA (Eigenfaces):**  
   - Stack vectorized face images; compute mean face; project onto top \(k\) eigenvectors of covariance.  

2. **LDA (Fisherfaces):**  
   - Compute within‑class (\(S_W\)) and between‑class (\(S_B\)) scatter matrices.  
   - Solve \(\max_w \frac{w^TS_Bw}{w^TS_Ww}\); select discriminant directions.  

3. **K‑Means Clustering:**  
   - Partition projected features into \(K\) clusters by minimizing within‑cluster variance; iterate until convergence.  

4. **Results & Discussion:**  
   - Show reconstruction error vs. retained dimensions for PCA.  
   - Classification accuracy for PCA vs. LDA.  
   - Effect of cluster count on unsupervised grouping of faces; discuss cluster purity.  

---

## Exercise 5 – ADSP 21: SVD & PCA on Video Data  
**Topic:** Singular Value Decomposition (SVD) and Principal Component Analysis (PCA) applied to video frames.  

**Key Steps & Analysis:**  
1. **Data Preparation:**  
   - Stack each video frame as a column of \(X\in\mathbb{R}^{T\times N}\).  

2. **SVD:**  
   - Compute \(X^T=U\Sigma V^T\); interpret singular values as energy in principal modes.  
   - Truncate to top 10 modes; reconstruct approximations and measure reconstruction error.  

3. **PCA on Covariance:**  
   - Compute covariance of test set \(X_oX_o^T\); compare PCA eigenvalues/truncation vs. SVD approach.  

4. **Feature Extraction & Clustering:**  
   - Project frames onto top 3 principal components; visualize clustering in 3D.  
   - Show scree plots; discuss percent variance explained.  

5. **Discussion:**  
   - Trade‑off between compression (mode count) and fidelity.  
   - Applicability to background subtraction and dynamic scene modeling.  

---




