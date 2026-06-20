import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LinearRegression
from pathlib import Path
import sys


def load_data(csv_path):
    """Load the matched cases CSV file."""
    df = pd.read_csv(csv_path)
    print(f"Loaded {len(df)} rows from {csv_path}")
    print(f"\nColumns: {df.columns.tolist()}")
    print(f"\nFirst few rows:")
    print(df.head(10))
    return df


def plot_data_by_stack_pairs(df, output_dir=None):
    """
    Plot weight vs size for each unique (stack1, stack2) pair.
    """
    # Get unique (stack1, stack2) pairs
    stack_pairs = df.groupby(['stack1', 'stack2']).size().reset_index()[['stack1', 'stack2']]
    
    print(f"\nFound {len(stack_pairs)} unique (stack1, stack2) pairs:")
    print(stack_pairs)
    
    # Create a figure with subplots
    n_pairs = len(stack_pairs)
    n_cols = min(3, n_pairs)
    n_rows = (n_pairs + n_cols - 1) // n_cols
    
    fig, axes = plt.subplots(n_rows, n_cols, figsize=(6*n_cols, 5*n_rows))
    if n_pairs == 1:
        axes = np.array([axes])
    axes = axes.flatten()
    
    for idx, (_, row) in enumerate(stack_pairs.iterrows()):
        stack1_val = row['stack1']
        stack2_val = row['stack2']
        
        # Filter data for this stack pair
        subset = df[(df['stack1'] == stack1_val) & (df['stack2'] == stack2_val)]
        
        # Plot
        ax = axes[idx]
        
        # Group by size and plot all weights for each size
        for size_val in sorted(subset['size'].unique()):
            size_data = subset[subset['size'] == size_val]
            weights = size_data['weight'].values
            sizes = [size_val] * len(weights)
            ax.scatter(sizes, weights, alpha=0.6, s=50)
        
        ax.set_xlabel('Size', fontsize=12)
        ax.set_ylabel('Weight', fontsize=12)
        ax.set_title(f'stack1={stack1_val}, stack2={stack2_val}', fontsize=14, fontweight='bold')
        ax.grid(True, alpha=0.3)
        
        # Print statistics
        print(f"\n(stack1={stack1_val}, stack2={stack2_val}):")
        print(f"  Size range: {subset['size'].min()} to {subset['size'].max()}")
        print(f"  Weight range: {subset['weight'].min()} to {subset['weight'].max()}")
        print(f"  Number of data points: {len(subset)}")
    
    # Hide unused subplots
    for idx in range(n_pairs, len(axes)):
        axes[idx].set_visible(False)
    
    plt.tight_layout()
    
    # Save figure
    if output_dir:
        output_path = Path(output_dir) / "weight_vs_size_by_stack_pairs.png"
        plt.savefig(output_path, dpi=150, bbox_inches='tight')
        print(f"\nSaved plot to {output_path}")
    
    plt.show()
    
    return stack_pairs


def perform_linear_regression(df, stack_pairs, output_dir=None):
    """
    Perform linear regression for each (stack1, stack2) pair.
    Returns a dictionary mapping (stack1, stack2) -> regression model.
    """
    models = {}
    results = []
    
    print("\n" + "="*70)
    print("LINEAR REGRESSION RESULTS")
    print("="*70)
    
    for _, row in stack_pairs.iterrows():
        stack1_val = row['stack1']
        stack2_val = row['stack2']
        
        # Filter data for this stack pair
        subset = df[(df['stack1'] == stack1_val) & (df['stack2'] == stack2_val)]
        
        # Prepare data for regression
        X = subset[['size']].values
        y = subset['weight'].values
        
        # Fit linear regression
        model = LinearRegression()
        model.fit(X, y)
        
        # Calculate R² score
        r2_score = model.score(X, y)
        
        # Store model
        models[(stack1_val, stack2_val)] = model
        
        # Store results
        results.append({
            'stack1': stack1_val,
            'stack2': stack2_val,
            'slope': model.coef_[0],
            'intercept': model.intercept_,
            'r2_score': r2_score
        })
        
        print(f"\n(stack1={stack1_val}, stack2={stack2_val}):")
        print(f"  weight = {model.coef_[0]:.4f} * size + {model.intercept_:.4f}")
        print(f"  R² score: {r2_score:.4f}")
    
    # Create a summary DataFrame
    results_df = pd.DataFrame(results)
    
    if output_dir:
        output_path = Path(output_dir) / "regression_results.csv"
        results_df.to_csv(output_path, index=False)
        print(f"\nSaved regression results to {output_path}")
    
    return models, results_df


def plot_regression_lines(df, stack_pairs, models, output_dir=None):
    """
    Plot the data points with fitted regression lines.
    """
    # Create a figure with subplots
    n_pairs = len(stack_pairs)
    n_cols = min(3, n_pairs)
    n_rows = (n_pairs + n_cols - 1) // n_cols
    
    fig, axes = plt.subplots(n_rows, n_cols, figsize=(6*n_cols, 5*n_rows))
    if n_pairs == 1:
        axes = np.array([axes])
    axes = axes.flatten()
    
    for idx, (_, row) in enumerate(stack_pairs.iterrows()):
        stack1_val = row['stack1']
        stack2_val = row['stack2']
        
        # Filter data for this stack pair
        subset = df[(df['stack1'] == stack1_val) & (df['stack2'] == stack2_val)]
        
        # Plot
        ax = axes[idx]
        
        # Scatter plot of actual data
        ax.scatter(subset['size'], subset['weight'], alpha=0.6, s=50, label='Actual data')
        
        # Get the model
        model = models[(stack1_val, stack2_val)]
        
        # Plot regression line
        size_range = np.linspace(subset['size'].min(), subset['size'].max(), 100)
        weight_pred = model.predict(size_range.reshape(-1, 1))
        ax.plot(size_range, weight_pred, 'r-', linewidth=2, label='Linear fit')
        
        # Add equation to plot
        equation = f'y = {model.coef_[0]:.2f}x + {model.intercept_:.2f}'
        r2 = model.score(subset[['size']].values, subset['weight'].values)
        ax.text(0.05, 0.95, equation + f'\nR² = {r2:.4f}', 
                transform=ax.transAxes, fontsize=10,
                verticalalignment='top', bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))
        
        ax.set_xlabel('Size', fontsize=12)
        ax.set_ylabel('Weight', fontsize=12)
        ax.set_title(f'stack1={stack1_val}, stack2={stack2_val}', fontsize=14, fontweight='bold')
        ax.grid(True, alpha=0.3)
        ax.legend()
    
    # Hide unused subplots
    for idx in range(n_pairs, len(axes)):
        axes[idx].set_visible(False)
    
    plt.tight_layout()
    
    # Save figure
    if output_dir:
        output_path = Path(output_dir) / "regression_fits.png"
        plt.savefig(output_path, dpi=150, bbox_inches='tight')
        print(f"\nSaved regression plot to {output_path}")
    
    plt.show()


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 reroll.py <csv_file> [output_dir]")
        print("\nExample:")
        print("  python3 reroll.py trained_Generator_matched_cases.csv")
        sys.exit(1)
    
    csv_path = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) >= 3 else Path(csv_path).parent
    
    # Create output directory if needed
    Path(output_dir).mkdir(parents=True, exist_ok=True)
    
    # Load data
    df = load_data(csv_path)
    
    # Plot raw data
    print("\n" + "="*70)
    print("PLOTTING DATA POINTS")
    print("="*70)
    stack_pairs = plot_data_by_stack_pairs(df, output_dir)
    
    # Perform linear regression
    models, results_df = perform_linear_regression(df, stack_pairs, output_dir)
    
    # Plot regression lines
    print("\n" + "="*70)
    print("PLOTTING REGRESSION FITS")
    print("="*70)
    plot_regression_lines(df, stack_pairs, models, output_dir)
    
    print("\n" + "="*70)
    print("DONE!")
    print("="*70)


if __name__ == "__main__":
    main()
