# Digital Signal Processing – CEID Exercises

This repository contains solutions and analyses for the five assigned exercises in the “Applications of Digital Signal Processing” course (CEID, Univ. of Patras). Each exercise is self‑contained in its own folder and comes with accompanying MATLAB/Python code, plots, and write‑ups.

---


## Exercise 1 – Spectral Content Estimation  
**Topic:** Spectral Content Estimation

**Key Steps & Analysis:**  

### 1. First‑Order Case
1. **Signal Model**  
   $$X(n) = A_1\,e^{j\omega_1 n} + W(n),\quad n=0,\dots,M-1.$$
2. **Autocorrelation Sequence**  
   $$r_{XX}(k) \;=\; E\{X(n+k)X^*(n)\}
   = |A_1|^2\,e^{j\omega_1 k} \;+\; \sigma_W^2\,\delta(k).$$
3. **Autocorrelation Matrix**  
   $$R_{XX}
   = \bigl[r_{XX}(i-j)\bigr]_{i,j=0}^{M-1}
   = |A_1|^2\,e\,e^H \;+\; \sigma_W^2\,I_M,$$  
   where  
   $$e = \begin{bmatrix}1 & e^{-j\omega_1} & \dots & e^{-j\omega_1(M-1)}\end{bmatrix}^T.$$
4. **Eigenstructure**  
   - **Largest eigenvalue:**  
     $$\lambda_1 = M\,|A_1|^2 + \sigma_W^2,\quad v_1 \propto e.$$  
   - **Remaining** \(M-1\) **eigenvalues:**  
     $$\lambda_2 = \cdots = \lambda_M = \sigma_W^2.$$
5. **Parameter Estimates**  
   - **Noise variance:**  
     $$\hat\sigma_W^2 = \lambda_M.$$  
   - **Signal power:**  
     $$|A_1|^2 = \frac{\lambda_1 - \lambda_M}{M}.$$  
   - **Frequency:**  
     $$\omega_1 = -\arg\bigl(v_1[2]\bigr).$$

---

### 2. \(P\)‑th Order Case
1. **Signal Model**  
   $$X(n) = \sum_{i=1}^P A_i\,e^{j\omega_i n} + W(n).$$
2. **Autocorrelation Sequence**  
   $$r_{XX}(k)
   = \sum_{i=1}^P |A_i|^2\,e^{j\omega_i k}
   + \sigma_W^2\,\delta(k).$$
3. **Autocorrelation Matrix**  
   $$R_{XX}
   = \sum_{i=1}^P |A_i|^2\,e_i\,e_i^H
   \;+\; \sigma_W^2\,I_M,$$  
   with steering vectors  
   $$e_i = \begin{bmatrix}1 & e^{-j\omega_i} & \dots & e^{-j\omega_i(M-1)}\end{bmatrix}^T.$$
4. **Eigenstructure**  
   - **Top \(P\) eigenvalues:**  
     $$\lambda_i = M\,|A_i|^2 + \sigma_W^2,\quad i=1,\dots,P.$$  
   - **Remaining** \(M-P\) **eigenvalues:**  
     $$\lambda_{P+1} = \cdots = \lambda_M = \sigma_W^2.$$
5. **Parameter Estimates**  
   - **Noise variance:**  
     $$\hat\sigma_W^2 = \lambda_M.$$  
   - **Powers:**  
     $$|A_i|^2 = \frac{\lambda_i - \lambda_M}{M},\quad i=1,\dots,P.$$  
   - **Frequencies:**  
     Recover each \(\omega_i\) from the phase progression of the corresponding eigenvector \(v_i\).

---


## Exercise 2 – Low‑Rank Modeling & Eigenfilters  
**Topic:** Low‑rank approximation of multidimensional signals via eigenfilter decomposition (Karhunen–Loève, PCA/SVD).  

**Key Steps & Analysis:**  
1. **Modeling**  
   - Represent a vector random process \(U\) with covariance  
     $$C_{UU} = Q\,\Lambda\,Q^T\,. $$  
   - Transmit only the top \(P\) principal components for compression.

2. **Noiseless vs. Noisy Channel**  
   - In the noise‑free case, reconstruction MSE is  
     $$\text{MSE} = \sum_{m=P+1}^{M} \lambda_m\,. $$  
   - Over an AWGN channel, show  
     $$\text{MSE} = \sum_{m=P+1}^{M} \lambda_m \;+\; P\,\sigma_W^2\,. $$

3. **Simulation**  
   - Load `U.mat` (100 realizations, \(M=10\,000\)).  
   - Estimate \(C_{UU}\); perform `eig` or `svd`; verify theoretical error curves vs. \(P\).  
   - Plot relative error vs. \(P\) for various channel SNRs; discuss regimes where low‑rank transmission is beneficial.

---

## Exercise 3 – Dictionary Learning & Sparse Coding (KSVD + Inpainting)  
**Topic:** KSVD algorithm for dictionary learning and sparse coding (Generalized OMP), plus applications to denoising & inpainting.  

**Key Steps & Analysis:**  
1. **KSVD & GenOMP**  
   - **Sparse Coding (P1):**  
     $$\min_X \|Y - D\,X\|_F^2 \quad\text{s.t.}\quad \|x_n\|_0 \le T,$$  
     solved via greedy atom selection (OMP).  
   - **Dictionary Update (P2):**  
     Update each atom by computing the SVD of the residual matrix restricted to the support of that atom.  

2. **Applications**  
   - **Denoising:** Represent noisy image patches with the learned dictionary and reconstruct the denoised image.  
   - **Inpainting:** Fill in missing pixels by sparse approximation on the known support.

3. **Implementation & Results**  
   - MATLAB (and Python bonus) code for both tasks.  
   - Side‑by‑side plots of original, degraded, and recovered images.  
   - Table of MSE vs. SNR for denoising and inpainting; discussion of how dictionary quality and sparsity level affect performance.

---

## Exercise 4 – PCA, LDA & K‑Means for Face Recognition  
**Topic:** Eigenfaces (PCA), Fisherfaces (LDA), and K‑means clustering for face classification.  

**Key Steps & Analysis:**  
1. **PCA (Eigenfaces):**  
   - Vectorize face images into columns; compute the mean face \(\mu\); form covariance  
     $$C = \frac{1}{N}\sum_{n=1}^N (x_n - \mu)(x_n - \mu)^T\,, $$  
     project onto the top \(k\) eigenvectors.

2. **LDA (Fisherfaces):**  
   - Compute within‑class scatter \(S_W\) and between‑class scatter \(S_B\).  
   - Solve  
     $$\max_w \frac{w^T S_B w}{w^T S_W w}$$  
     to find the most discriminant directions.

3. **K‑Means Clustering:**  
   - Cluster the projected feature vectors into \(K\) groups by minimizing within‑cluster variance.

4. **Results & Discussion:**  
   - Reconstruction error vs. retained PCA dimensions.  
   - Classification accuracy: PCA vs. LDA.  
   - Effect of \(K\) on unsupervised grouping; cluster purity analysis.

---

## Exercise 5 –  SVD & PCA on Video Data  
**Topic:** Singular Value Decomposition (SVD) and Principal Component Analysis (PCA) applied to video frames.  

**Key Steps & Analysis:**  
1. **Data Preparation:**  
   - Stack each video frame as a column of  
     $$X \in \mathbb{R}^{T \times N}\,. $$

2. **SVD:**  
   - Compute  
     $$X = U\,\Sigma\,V^T\,, $$  
     interpret singular values \(\sigma_i\) as the energy in each principal mode.  
   - Truncate to the top 10 modes; reconstruct and measure the reconstruction error.

3. **PCA on Covariance:**  
   - Compute the covariance \(X\,X^T\); compare its eigenvalues and truncation performance to the SVD approach.

4. **Feature Extraction & Clustering:**  
   - Project frames onto the top 3 principal components; visualize clustering in 3D.  
   - Present scree plot of variance explained.

5. **Discussion:**  
   - Trade‑off between compression (number of modes) and fidelity.  
   - Applications to background subtraction and dynamic scene modelling.

---




